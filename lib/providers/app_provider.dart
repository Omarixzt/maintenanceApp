import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Index;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import '../models/app_models.dart';
import '../services/isar_service.dart';

class AppProvider extends ChangeNotifier {
  List<MaintenanceTicket> tickets = [];
  List<LocalPart> inventory = [];
  
  String telegramBotToken = '';
  String telegramChatId = '';
  String printerMac = '';

  List<DeviceBrand> brands = [];
  List<QuickPrice> quickPrices = [];
  
  // القائمة التي ستحمل اقتراحات أسعار الموردين للموديل المحدد حالياً
  List<SupplierPrice> currentSuggestedPrices = [];

  AppProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    tickets = await IsarService.db.maintenanceTickets.where().sortByReceivedDateDesc().findAll();
    inventory = await IsarService.db.localParts.where().findAll();
    
    telegramBotToken = await IsarService.getSetting('bot_token') ?? '';
    telegramChatId = await IsarService.getSetting('chat_id') ?? '';
    printerMac = await IsarService.getSetting('printer_mac') ?? '';
    
    await loadDynamicData();
  }

  Future<void> loadDynamicData() async {
    brands = await IsarService.db.deviceBrands.where().findAll();
    if (brands.isEmpty) {
      final defaultBrand = DeviceBrand()..name = 'SAMSUNG'..models = ['Galaxy S22 Ultra', 'Galaxy A54'];
      await IsarService.db.writeTxn(() async => await IsarService.db.deviceBrands.put(defaultBrand));
      brands.add(defaultBrand);
    }

    quickPrices = await IsarService.db.quickPrices.where().sortByIndexId().findAll();
    if (quickPrices.isEmpty) {
      final defaults = [3.0, 5.0, 8.0, 10.0];
      await IsarService.db.writeTxn(() async {
        for (int i = 0; i < defaults.length; i++) {
          final qp = QuickPrice()..indexId = i..price = defaults[i];
          await IsarService.db.quickPrices.put(qp);
          quickPrices.add(qp);
        }
      });
    }
    
    // استدعاء دالة الترتيب المخصص للشركات عند تشغيل التطبيق
    await applyCustomBrandOrder();
  }

  // -----------------------------------------------------------------
  // قسم ترتيب الشركات المخصص (السحب والإفلات والحفظ)
  // -----------------------------------------------------------------

  Future<void> applyCustomBrandOrder() async {
    String? savedOrder = await IsarService.getSetting('custom_brand_order');
    
    if (savedOrder != null && savedOrder.isNotEmpty) {
      // إذا كان هناك ترتيب محفوظ مسبقاً، قم بتطبيقه
      List<String> orderList = savedOrder.split(',');
      brands.sort((a, b) {
        int indexA = orderList.indexOf(a.name);
        int indexB = orderList.indexOf(b.name);
        if (indexA == -1 && indexB == -1) return a.name.compareTo(b.name);
        if (indexA == -1) return 1; // الشركات الجديدة تذهب للأسفل
        if (indexB == -1) return -1;
        return indexA.compareTo(indexB);
      });
    } else {
      // الترتيب الافتراضي الأولي
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
    // تحديث مكان الشركة في القائمة
    final brand = brands.removeAt(oldIndex);
    brands.insert(newIndex, brand);
    
    // حفظ الترتيب الجديد في قاعدة البيانات المحلية
    String newOrder = brands.map((b) => b.name).join(',');
    await IsarService.saveSetting('custom_brand_order', newOrder);
    
    notifyListeners();
  }

  // -----------------------------------------------------------------
  // قسم مزامنة وأسعار الموردين (التنين، مؤسسة ورد، إلخ)
  // -----------------------------------------------------------------
  
  Future<String> syncPricesFromCloud() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('prices_catalog').get();
      
      if (snapshot.docs.isEmpty) {
        return "لم يتم العثور على بيانات. تأكد من رفع البيانات إلى prices_catalog.";
      }

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
          if (!brandModelsMap.containsKey(brand)) {
            brandModelsMap[brand] = {};
          }
          brandModelsMap[brand]!.add(model);
        }
      }

      List<DeviceBrand> extractedBrands = [];
      brandModelsMap.forEach((brandName, modelsSet) {
        extractedBrands.add(
          DeviceBrand()
            ..name = brandName
            ..models = (modelsSet.toList()..sort()) // ترتيب الموديلات داخل الشركة أبجدياً
        );
      });

      await IsarService.db.writeTxn(() async {
        await IsarService.db.supplierPrices.clear();
        await IsarService.db.deviceBrands.clear();
        
        await IsarService.db.supplierPrices.putAll(newPrices);
        await IsarService.db.deviceBrands.putAll(extractedBrands);
      });
      
      brands = extractedBrands;
      
      // تطبيق الترتيب المحفوظ بعد جلب الشركات الجديدة
      await applyCustomBrandOrder();
      
      return "نجاح: تم جلب ${newPrices.length} تسعيرة و ${brands.length} شركة.";
    } catch (e) {
      print("Sync Error: $e");
      return "حدث خطأ: $e";
    }
  }

  Future<void> fetchSuggestedPricesForModel(String model) async {
    // جلب الأسعار للموديل المحدد من قاعدة البيانات
    final results = await IsarService.db.supplierPrices
        .where()
        .filter()
        .deviceModelContains(model, caseSensitive: false)
        .findAll();

    // الترتيب: من السعر الأقل إلى السعر الأعلى
    results.sort((a, b) => a.price.compareTo(b.price));

    currentSuggestedPrices = results;
    notifyListeners();
  }

  // -----------------------------------------------------------------
  // قسم إدارة الشركات والموديلات والتسعير السريع
  // -----------------------------------------------------------------

  Future<DeviceBrand> addBrand(String brandName) async {
    final newBrand = DeviceBrand()..name = brandName.toUpperCase().trim()..models = [];
    await IsarService.db.writeTxn(() async => await IsarService.db.deviceBrands.put(newBrand));
    brands.add(newBrand);
    // تحديث الترتيب المحفوظ ليشمل الشركة الجديدة
    String newOrder = brands.map((b) => b.name).join(',');
    await IsarService.saveSetting('custom_brand_order', newOrder);
    notifyListeners();
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

  // -----------------------------------------------------------------
  // قسم التذاكر والمخزون (تم استكمال النواقص هنا)
  // -----------------------------------------------------------------

  Future<void> addTicket(MaintenanceTicket ticket) async {
    await IsarService.db.writeTxn(() async {
      await IsarService.db.maintenanceTickets.put(ticket);
    });
    tickets.insert(0, ticket);
    notifyListeners();
  }

  Future<void> updateTicketStatus(MaintenanceTicket ticket, String newStatus) async {
    ticket.status = newStatus;
    
    if (newStatus == 'Delivered' && ticket.syncStatus == 0) {
      try {
        await FirebaseFirestore.instance.collection('pos_sync').doc(ticket.firebaseId).set({
          'customerName': ticket.customerName,
          'deviceModel': ticket.deviceModel,
          'finalCost': ticket.finalCost,
          'netProfit': ticket.netProfit,
          'timestamp': FieldValue.serverTimestamp(),
          'ticketId': ticket.firebaseId,
        });
        ticket.syncStatus = 1;
      } catch (e) {
        print("Firebase offline cache handling the payload.");
      }
    }

    await IsarService.db.writeTxn(() async {
      await IsarService.db.maintenanceTickets.put(ticket);
    });
    notifyListeners();
  }

  // 1. إضافة قطعة جديدة للمخزون (تمت إضافتها)
  Future<void> addInventoryPart(LocalPart part) async {
    await IsarService.db.writeTxn(() async {
      await IsarService.db.localParts.put(part);
    });
    inventory.add(part);
    notifyListeners();
  }

  // 2. خصم قطعة من المخزون فقط دون ربطها بتذكرة معينة (تمت إضافتها لتتوافق مع واجهة الورشة)
  Future<bool> deductPartFromInventory(LocalPart part) async {
    if (part.quantity <= 0) return false;

    part.quantity -= 1;
    await IsarService.db.writeTxn(() async {
      await IsarService.db.localParts.put(part);
    });
    notifyListeners();
    return true;
  }

  // 3. خصم قطعة من المخزون مع ربطها بتذكرة لحساب صافي الربح (موجودة مسبقاً ومفيدة محاسبياً)
  Future<bool> usePartForTicket(MaintenanceTicket ticket, LocalPart part) async {
    if (part.quantity <= 0) return false;

    part.quantity -= 1;
    ticket.netProfit = ticket.finalCost - part.costPrice;

    await IsarService.db.writeTxn(() async {
      await IsarService.db.localParts.put(part);
      await IsarService.db.maintenanceTickets.put(ticket);
    });

    notifyListeners();
    return true;
  }

  // -----------------------------------------------------------------
  // قسم الإعدادات والتقارير
  // -----------------------------------------------------------------

  Future<void> saveSettings(String token, String chat, String mac) async {
    telegramBotToken = token;
    telegramChatId = chat;
    printerMac = mac;
    
    await IsarService.saveSetting('bot_token', token);
    await IsarService.saveSetting('chat_id', chat);
    await IsarService.saveSetting('printer_mac', mac);
    
    notifyListeners();
  }

  Future<bool> sendMonthlyArchiveToTelegram() async {
    if (telegramBotToken.isEmpty || telegramChatId.isEmpty) return false;

    try {
      final now = DateTime.now();
      final currentMonthTickets = tickets.where((t) {
        final d = DateTime.parse(t.receivedDate);
        return d.month == now.month && d.year == now.year;
      }).toList();

      StringBuffer csvData = StringBuffer();
      csvData.writeln("ID,Customer,Device,Status,Final Cost,Net Profit,Date");
      for (var t in currentMonthTickets) {
        csvData.writeln("${t.firebaseId},${t.customerName},${t.deviceModel},${t.status},${t.finalCost},${t.netProfit},${t.receivedDate}");
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.telegram.org/bot$telegramBotToken/sendDocument'),
      );
      
      request.fields['chat_id'] = telegramChatId;
      request.fields['caption'] = 'Archive for ${DateFormat('MMMM yyyy').format(now)}';
      request.files.add(
        http.MultipartFile.fromString(
          'document', 
          csvData.toString(), 
          filename: 'Archive_${now.month}_${now.year}.csv'
        )
      );

      var response = await request.send();
      return response.statusCode == 200;
    } catch (e) {
      print("Telegram API Error: $e");
      return false;
    }
  }
}