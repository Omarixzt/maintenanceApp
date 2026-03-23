import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isar/isar.dart';
import '../models/app_models.dart';
import '../services/isar_service.dart';

class InventoryProvider extends ChangeNotifier {
  List<LocalPart> inventory = [];
  List<DeviceBrand> brands = [];
  List<QuickPrice> quickPrices = [];
  List<SupplierPrice> currentSuggestedPrices = [];

  InventoryProvider() {
    _loadInventoryData();
  }

  Future<void> _loadInventoryData() async {
    String? shopId = await IsarService.getSetting('active_shop_id');
    
    // تحميل القطع الخاصة بهذا المحل فقط وغير المحذوفة
    inventory = await IsarService.db.localParts
        .filter()
        .shopIdEqualTo(shopId ?? '')
        .isDeletedEqualTo(false)
        .findAll();
        
    brands = await IsarService.db.deviceBrands.where().findAll();
    
    if (brands.isEmpty) {
      final defaultBrand = DeviceBrand()..name = 'SAMSUNG'..models = ['Galaxy S22 Ultra', 'Galaxy A54'];
      await IsarService.db.writeTxn(() async => await IsarService.db.deviceBrands.put(defaultBrand));
      brands.add(defaultBrand);
    }

    quickPrices = await IsarService.db.quickPrices.where().sortByIndexId().findAll();
    if (quickPrices.isEmpty) {
      final defaults = [3.0, 5.0, 7.0, 10.0, 15.0]; 
      await IsarService.db.writeTxn(() async {
        for (int i = 0; i < defaults.length; i++) {
          final qp = QuickPrice()..indexId = i..price = defaults[i];
          await IsarService.db.quickPrices.put(qp);
          quickPrices.add(qp);
        }
      });
    }
    await applyCustomBrandOrder();
  }

  Future<void> applyCustomBrandOrder() async {
    String? savedOrder = await IsarService.getSetting('custom_brand_order');
    if (savedOrder != null && savedOrder.isNotEmpty) {
      List<String> orderList = savedOrder.split(',');
      brands.sort((a, b) {
        int indexA = orderList.indexOf(a.name);
        int indexB = orderList.indexOf(b.name);
        if (indexA == -1 && indexB == -1) return a.name.compareTo(b.name);
        if (indexA == -1) return 1;
        if (indexB == -1) return -1;
        return indexA.compareTo(indexB);
      });
    } else {
      final List<String> defaultOrder = ['APPLE', 'SAMSUNG', 'HUAWEI', 'TECNO', 'INFINIX'];
      brands.sort((a, b) {
        int indexA = defaultOrder.indexOf(a.name.toUpperCase());
        int indexB = defaultOrder.indexOf(b.name.toUpperCase());
        if (indexA != -1 && indexB != -1) return indexA.compareTo(indexB);
        if (indexA != -1) return -1;
        if (indexB != -1) return 1;
        return a.name.compareTo(b.name);
      });
    }
    notifyListeners();
  }

  Future<void> reorderBrands(int oldIndex, int newIndex) async {
    final brand = brands.removeAt(oldIndex);
    brands.insert(newIndex, brand);
    String newOrder = brands.map((b) => b.name).join(',');
    await IsarService.saveSetting('custom_brand_order', newOrder);
    notifyListeners();
  }

  Future<DeviceBrand> addBrand(String brandName) async {
    final newBrand = DeviceBrand()..name = brandName.toUpperCase().trim()..models = [];
    await IsarService.db.writeTxn(() async => await IsarService.db.deviceBrands.put(newBrand));
    brands.add(newBrand);
    await applyCustomBrandOrder();
    return newBrand;
  }

  Future<void> addModelToBrand(DeviceBrand brand, String modelName) async {
    brand.models = List.from(brand.models)..add(modelName.toUpperCase().trim());
    await IsarService.db.writeTxn(() async => await IsarService.db.deviceBrands.put(brand));
    notifyListeners();
  }

  Future<void> updateQuickPrice(QuickPrice qp, double newPrice) async {
    qp.price = newPrice;
    await IsarService.db.writeTxn(() async => await IsarService.db.quickPrices.put(qp));
    notifyListeners();
  }

  // --- دوال إدارة قطع المخزون بذكاء المزامنة ---
  
  Future<void> addInventoryPart(LocalPart part) async {
    String? shopId = await IsarService.getSetting('active_shop_id');
    part.shopId = shopId ?? ''; // ختم القطعة برقم المحل
    part.syncStatus = 0;
    part.updatedAt = DateTime.now().millisecondsSinceEpoch;
    
    await IsarService.db.writeTxn(() async => await IsarService.db.localParts.put(part));
    inventory.insert(0, part);
    notifyListeners();
    syncInventoryWithCloud(); 
  }

  Future<void> updateInventoryPart(LocalPart part) async {
    part.syncStatus = 0;
    part.updatedAt = DateTime.now().millisecondsSinceEpoch;
    await IsarService.db.writeTxn(() async => await IsarService.db.localParts.put(part));
    
    final index = inventory.indexWhere((p) => p.isarId == part.isarId);
    if (index != -1) {
      inventory[index] = part;
      notifyListeners();
    }
    syncInventoryWithCloud();
  }

  Future<void> deleteInventoryPart(LocalPart part) async {
    part.isDeleted = true;
    part.syncStatus = 0;
    part.updatedAt = DateTime.now().millisecondsSinceEpoch;
    
    await IsarService.db.writeTxn(() async => await IsarService.db.localParts.put(part));
    inventory.removeWhere((p) => p.isarId == part.isarId);
    notifyListeners();
    syncInventoryWithCloud();
  }

  Future<bool> deductPartFromInventory(LocalPart part) async {
    if (part.quantity <= 0) return false;
    part.quantity -= 1;
    part.syncStatus = 0;
    part.updatedAt = DateTime.now().millisecondsSinceEpoch;
    
    await IsarService.db.writeTxn(() async => await IsarService.db.localParts.put(part));
    notifyListeners();
    syncInventoryWithCloud();
    return true;
  }

  // --- الدالة الذكية للمزامنة (تم التحديث لتدعم SaaS) ---
  Future<String> syncInventoryWithCloud() async {
    try {
      String? shopId = await IsarService.getSetting('active_shop_id');
      if (shopId == null || shopId.isEmpty) return "يرجى تسجيل الدخول أولاً.";

      final isar = IsarService.db;

      // 1. رفع التعديلات المحلية الخاصة بهذا المحل فقط
      final pendingParts = await isar.localParts.filter().shopIdEqualTo(shopId).syncStatusEqualTo(0).findAll();
      int uploadedCount = 0;
      
      for (var part in pendingParts) {
        if (part.partId == null || part.partId!.isEmpty) continue;
        final docRef = FirebaseFirestore.instance.collection('local_inventory').doc(part.partId);

        if (part.isDeleted) {
          await docRef.delete(); 
          await isar.writeTxn(() async => await isar.localParts.delete(part.isarId)); 
        } else {
          await docRef.set(part.toMap(), SetOptions(merge: true));
          part.syncStatus = 1;
          await isar.writeTxn(() async => await isar.localParts.put(part));
        }
        uploadedCount++;
      }

      // 2. سحب التعديلات السحابية الخاصة بهذا المحل فقط
      final lastSyncedPart = await isar.localParts.filter().shopIdEqualTo(shopId).sortByUpdatedAtDesc().findFirst();
      int lastSyncTime = lastSyncedPart?.updatedAt ?? 0;

      final snapshot = await FirebaseFirestore.instance
          .collection('local_inventory')
          .where('shopId', isEqualTo: shopId) // <--- التعديل الجوهري هنا
          .where('updatedAt', isGreaterThan: lastSyncTime)
          .get();

      int downloadedCount = 0;
      await isar.writeTxn(() async {
        for (var doc in snapshot.docs) {
          final cloudPart = LocalPart.fromMap(doc.data());
          final existingPart = await isar.localParts.filter().partIdEqualTo(cloudPart.partId).findFirst();
          
          if (cloudPart.isDeleted) {
            if (existingPart != null) await isar.localParts.delete(existingPart.isarId);
          } else {
            if (existingPart != null) cloudPart.isarId = existingPart.isarId;
            await isar.localParts.put(cloudPart);
            downloadedCount++;
          }
        }
      });

      if (downloadedCount > 0) {
        inventory = await isar.localParts.filter().shopIdEqualTo(shopId).isDeletedEqualTo(false).findAll();
        notifyListeners();
      }

      if (uploadedCount == 0 && downloadedCount == 0) {
        return "المخزون محدث بالكامل.";
      }
      return "تمت المزامنة بنجاح.";
    } catch (e) {
      debugPrint("خطأ في مزامنة المخزون: $e");
      return "فشلت المزامنة. تأكد من اتصال الإنترنت.";
    }
  }

  void clearSuggestedPrices() {
    currentSuggestedPrices.clear();
    notifyListeners();
  }

  Future<void> fetchSuggestedPricesForModel(String? brandName, String typedModel, String partType) async {
    try {
      final allPrices = await IsarService.db.supplierPrices.where().findAll();
      Map<String, SupplierPrice> uniquePrices = {};
      String localBrand = (brandName ?? '').trim().toUpperCase();
      String localModel = typedModel.trim().toUpperCase();

      for (var sp in allPrices) {
        String dbModel = sp.deviceModel.trim().toUpperCase();
        String dbBrand = sp.deviceBrand.trim().toUpperCase();

        if (dbModel == localModel) {
          bool isBrandMatch = true;
          if (localBrand.isNotEmpty && dbBrand.isNotEmpty) {
            bool isApple = (localBrand.contains('APPLE') || localBrand.contains('IPHONE') || localBrand.contains('ابل')) && 
                           (dbBrand.contains('APPLE') || dbBrand.contains('IPHONE') || dbBrand.contains('ابل'));
            isBrandMatch = dbBrand == localBrand || dbBrand.contains(localBrand) || localBrand.contains(dbBrand) || isApple;
          }
          if (isBrandMatch) {
            String key = '${sp.partQuality}_${sp.price}_${sp.supplierName}'.toUpperCase();
            uniquePrices[key] = sp; 
          }
        }
      }
      if (uniquePrices.isEmpty) {
        for (var sp in allPrices) {
          if (sp.deviceModel.trim().toUpperCase() == localModel) {
            String key = '${sp.partQuality}_${sp.price}_${sp.supplierName}'.toUpperCase();
            uniquePrices[key] = sp;
          }
        }
      }
      List<SupplierPrice> finalPrices = uniquePrices.values.toList();
      finalPrices.sort((a, b) => a.price.compareTo(b.price));

      final localMatches = inventory.where((part) => 
        part.deviceModel.trim().toUpperCase() == localModel && 
        part.partType == partType &&
        part.quantity > 0
      ).toList();

      List<SupplierPrice> localSuggested = [];
      for (var part in localMatches) {
        localSuggested.add(SupplierPrice()
          ..supplierName = '⭐ المخزون المحلي (متوفر ${part.quantity}) ⭐'
          ..deviceBrand = part.deviceBrand
          ..deviceModel = part.deviceModel
          ..partQuality = part.partName 
          ..price = part.costPrice
        );
      }

      currentSuggestedPrices = [...localSuggested, ...finalPrices];
      notifyListeners();
    } catch (e) {
      currentSuggestedPrices = [];
      notifyListeners();
    }
  }

  Future<String> syncPricesFromCloud() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('prices_catalog').get();
      if (snapshot.docs.isEmpty) return "لم يتم العثور على بيانات في السحابة.";
      
      final newPrices = snapshot.docs.map((doc) {
        final data = doc.data();
        return SupplierPrice()
          ..supplierName = data['supplierName']?.toString() ?? 'Unknown'
          ..deviceBrand = data['deviceBrand']?.toString() ?? ''
          ..deviceModel = data['deviceModel']?.toString() ?? ''
          ..partQuality = data['partQuality']?.toString() ?? ''
          ..price = double.tryParse(data['price']?.toString() ?? '0') ?? 0.0;
      }).toList();

      Map<String, Set<String>> brandModelsMap = {};
      for (var item in newPrices) {
        String brand = item.deviceBrand.toUpperCase().trim();
        String model = item.deviceModel.toUpperCase().trim();
        if (brand.isNotEmpty && model.isNotEmpty) {
          if (!brandModelsMap.containsKey(brand)) brandModelsMap[brand] = {};
          brandModelsMap[brand]!.add(model);
        }
      }

      List<DeviceBrand> extractedBrands = [];
      brandModelsMap.forEach((brandName, modelsSet) {
        extractedBrands.add(DeviceBrand()..name = brandName..models = (modelsSet.toList()..sort()));
      });

      await IsarService.db.writeTxn(() async {
        await IsarService.db.supplierPrices.clear();
        await IsarService.db.deviceBrands.clear();
        await IsarService.db.supplierPrices.putAll(newPrices);
        await IsarService.db.deviceBrands.putAll(extractedBrands);
      });
      brands = extractedBrands;
      await applyCustomBrandOrder();
      return "تم جلب ${newPrices.length} تسعيرة بنجاح.";
    } catch (e) {
      return "حدث خطأ: $e";
    }
  }
}