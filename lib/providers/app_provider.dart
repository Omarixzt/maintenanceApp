import 'dart:async';
import 'dart:io'; // <-- تم إضافة هذه المكتبة للتعامل مع حذف الملفات
import 'package:connectivity_plus/connectivity_plus.dart';
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
  List<SupplierPrice> currentSuggestedPrices = [];

  // متغيرات التنظيف التلقائي للصور
  bool autoCleanupEnabled = false;
  int autoCleanupDays = 90;

  // متغير للتحكم في الاستماع اللحظي وإغلاقه عند الخروج
  StreamSubscription<QuerySnapshot>? _ticketsSubscription;
  // متغير لمراقبة حالة الاتصال بالإنترنت
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  AppProvider() {
    _loadData();
    _setupConnectivityListener();
  }

  Future<void> _loadData() async {
    // 1. جلب البيانات من Isar لعرضها فوراً وبدون إنترنت (غير مؤرشفة فقط للورشة)
    tickets = await IsarService.db.maintenanceTickets
        .filter()
        .isArchivedEqualTo(false)
        .sortByReceivedDateDesc()
        .findAll();
        
    inventory = await IsarService.db.localParts.where().findAll();
    
    telegramBotToken = await IsarService.getSetting('bot_token') ?? '';
    telegramChatId = await IsarService.getSetting('chat_id') ?? '';
    printerMac = await IsarService.getSetting('printer_mac') ?? '';
    
    // تحميل إعدادات التنظيف التلقائي
    String? cleanupEnabledStr = await IsarService.getSetting('auto_cleanup_enabled');
    autoCleanupEnabled = cleanupEnabledStr == 'true';

    String? cleanupDaysStr = await IsarService.getSetting('auto_cleanup_days');
    autoCleanupDays = int.tryParse(cleanupDaysStr ?? '90') ?? 90;

    // تشغيل التنظيف التلقائي بالخلفية عند بدء التطبيق إذا كان مفعلاً
    if (autoCleanupEnabled) {
      cleanupOldImages();
    }

    await loadDynamicData();
    
    // 2. تشغيل الاستماع اللحظي لمزامنة الأجهزة مع فايربيس
    _startRealtimeSync();

    // 3. محاولة مزامنة أي تذاكر معلقة عند تشغيل التطبيق
    syncAllPendingTickets();
  }

  // -----------------------------------------------------------------
  // قسم إدارة مساحة التخزين (التنظيف التلقائي للصور)
  // -----------------------------------------------------------------

  Future<void> updateAutoCleanupSettings(bool enabled, int days) async {
    autoCleanupEnabled = enabled;
    autoCleanupDays = days;
    await IsarService.saveSetting('auto_cleanup_enabled', enabled.toString());
    await IsarService.saveSetting('auto_cleanup_days', days.toString());
    notifyListeners();
  }

  Future<int> cleanupOldImages({bool force = false}) async {
    // إذا كان الخيار معطلاً ولم يتم التشغيل الإجباري (اليدوي)، توقف
    if (!autoCleanupEnabled && !force) return 0;

    int deletedImagesCount = 0;
    final isar = IsarService.db;
    final thresholdDate = DateTime.now().subtract(Duration(days: autoCleanupDays));

    // جلب الأجهزة المؤرشفة فقط
    final archivedTickets = await isar.maintenanceTickets.filter().isArchivedEqualTo(true).findAll();

    for (var ticket in archivedTickets) {
      try {
        DateTime received = DateTime.parse(ticket.receivedDate);
        
        // التحقق مما إذا كان الجهاز أقدم من المدة المحددة للتنظيف
        if (received.isBefore(thresholdDate)) {
          bool updated = false;
          
          // حذف صورة قبل الإصلاح
          if (ticket.imagePath != null) {
            final file = File(ticket.imagePath!);
            if (await file.exists()) {
              await file.delete();
              deletedImagesCount++;
            }
            ticket.imagePath = null; // إزالة مسار الصورة من قاعدة البيانات
            updated = true;
          }
          
          // حذف صورة بعد الإصلاح
          if (ticket.imagePathAfter != null) {
            final file = File(ticket.imagePathAfter!);
            if (await file.exists()) {
              await file.delete();
              deletedImagesCount++;
            }
            ticket.imagePathAfter = null;
            updated = true;
          }

          // تحديث التذكرة في قاعدة البيانات المحلية لحفظ التغييرات
          if (updated) {
            await isar.writeTxn(() async {
              await isar.maintenanceTickets.put(ticket);
            });
          }
        }
      } catch (e) {
        debugPrint('خطأ في معالجة التاريخ أو حذف الملف: $e');
      }
    }
    
    if (deletedImagesCount > 0) notifyListeners();
    return deletedImagesCount;
  }

  // -----------------------------------------------------------------
  // قسم مراقبة الاتصال والمزامنة التلقائية (Offline Support)
  // -----------------------------------------------------------------

  void _setupConnectivityListener() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      // إذا تم استعادة الاتصال عبر الواي فاي أو البيانات
      if (results.contains(ConnectivityResult.mobile) || results.contains(ConnectivityResult.wifi)) {
        debugPrint("تم استعادة الاتصال بالإنترنت.. جاري مزامنة التذاكر المعلقة");
        syncAllPendingTickets();
      }
    });
  }

  Future<void> syncAllPendingTickets() async {
    try {
      // جلب جميع التذاكر التي تحمل syncStatus = 0 (لم ترفع بعد)
      final pendingTickets = await IsarService.db.maintenanceTickets
          .filter()
          .syncStatusEqualTo(0)
          .findAll();

      if (pendingTickets.isEmpty) return;

      for (var ticket in pendingTickets) {
        await _syncTicketToFirebase(ticket);
      }
    } catch (e) {
      debugPrint("خطأ أثناء مزامنة التذاكر المعلقة: $e");
    }
  }

  // -----------------------------------------------------------------
  // قسم الاستماع اللحظي (Real-time Sync) الموفر للتكلفة
  // -----------------------------------------------------------------
  void _startRealtimeSync() {
  _ticketsSubscription?.cancel();
  _ticketsSubscription = FirebaseFirestore.instance
      .collection('tickets')
      .snapshots()
      .listen((snapshot) async {
    final isar = IsarService.db;
    
    for (var change in snapshot.docChanges) {
      if (change.type == DocumentChangeType.added || change.type == DocumentChangeType.modified) {
        final incomingData = change.doc.data();
        if (incomingData != null) {
          final cloudTicket = MaintenanceTicket.fromMap(incomingData);
          
          // البحث عن النسخة المحلية
          final localTicket = await isar.maintenanceTickets
              .filter()
              .firebaseIdEqualTo(cloudTicket.firebaseId)
              .findFirst();

          if (localTicket != null) {
            // منطق حل التضارب: الكتابة الأحدث تفوز
            // إذا كانت النسخة المحلية بانتظار الرفع (syncStatus == 0) وهي أحدث من السحابة، نتجاهل تحديث السحابة
            if (localTicket.syncStatus == 0 && localTicket.updatedAt > cloudTicket.updatedAt) {
              continue; 
            }
          }

          // إذا لم يوجد تضارب أو كانت السحابة أحدث، نحدث محلياً
          await isar.writeTxn(() async {
            await isar.maintenanceTickets.put(cloudTicket);
          });
        }
      }
    }
    _loadData();
  });
  }

  @override
  void dispose() {
    _ticketsSubscription?.cancel();
    _connectivitySubscription?.cancel();
    super.dispose();
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
      // إعداد الأسعار السريعة الافتراضية كما طلبت (5 أسعار تشمل الرقم 7)
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

  // -----------------------------------------------------------------
  // المزامنة الصاعدة (رفع التعديلات للسحابة)
  // -----------------------------------------------------------------
  Future<void> _syncTicketToFirebase(MaintenanceTicket ticket) async {
    try {
      if (ticket.firebaseId == null || ticket.firebaseId!.isEmpty) return;
      
      await FirebaseFirestore.instance
          .collection('maintenance_tickets')
          .doc(ticket.firebaseId)
          .set(ticket.toMap(), SetOptions(merge: true));

      // تحديث حالة المزامنة محلياً لتدل على النجاح
      ticket.syncStatus = 1; 
      await IsarService.db.writeTxn(() async {
        await IsarService.db.maintenanceTickets.put(ticket);
      });
      
      debugPrint('تمت المزامنة بنجاح لفايربيس: ${ticket.deviceModel}');
    } catch (e) {
      // في حال الفشل، نضمن بقاء الحالة 0 لمحاولة المزامنة لاحقاً عبر المراقب
      ticket.syncStatus = 0;
      await IsarService.db.writeTxn(() async {
        await IsarService.db.maintenanceTickets.put(ticket);
      });
      debugPrint('فشلت المزامنة، تم الحفظ محلياً للمحاولة لاحقاً: $e');
    }
  }

  // -----------------------------------------------------------------
  // قسم ترتيب الشركات المخصص
  // -----------------------------------------------------------------

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
  
  // -----------------------------------------------------------------
  // قسم أسعار الموردين
  // -----------------------------------------------------------------

  Future<String> syncPricesFromCloud() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('prices_catalog').get();
      if (snapshot.docs.isEmpty) {
        return "لم يتم العثور على بيانات في السحابة.";
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

  Future<void> fetchSuggestedPricesForModel(String? brandName, String typedModel) async {
    try {
      // جلب الأسعار من قاعدة البيانات المحلية Isar بدلاً من فايربيس
      final allPrices = await IsarService.db.supplierPrices.where().findAll();

      Map<String, SupplierPrice> uniquePrices = {};
      
      // تنظيف الكلمات التي أدخلتها من أي مسافات زائدة
      String localBrand = (brandName ?? '').trim().toUpperCase();
      String localModel = typedModel.trim().toUpperCase();

      for (var sp in allPrices) {
        // تنظيف الكلمات الموجودة في قاعدة البيانات
        String dbModel = sp.deviceModel.trim().toUpperCase();
        String dbBrand = sp.deviceBrand.trim().toUpperCase();

        // 2. التحقق من الموديل
        if (dbModel == localModel) {
          
          // 3. فلترة الشركة (لعزل شاومي عن آبل)
          bool isBrandMatch = true;
          if (localBrand.isNotEmpty && dbBrand.isNotEmpty) {
            // معالجة مشكلة اختلاف كتابة (Apple / iPhone / ابل)
            bool isApple = (localBrand.contains('APPLE') || localBrand.contains('IPHONE') || localBrand.contains('ابل')) && 
                           (dbBrand.contains('APPLE') || dbBrand.contains('IPHONE') || dbBrand.contains('ابل'));
            
            // المطابقة المرنة للشركة
            isBrandMatch = dbBrand == localBrand || dbBrand.contains(localBrand) || localBrand.contains(dbBrand) || isApple;
          }

          if (isBrandMatch) {
            // دمج (الجودة + السعر + المورد) لمنع التكرار الحرفي
            String key = '${sp.partQuality}_${sp.price}_${sp.supplierName}'.toUpperCase();
            uniquePrices[key] = sp; 
          }
        }
      }

      // 🌟 صمام الأمان (Fallback):
      if (uniquePrices.isEmpty) {
        for (var sp in allPrices) {
          if (sp.deviceModel.trim().toUpperCase() == localModel) {
            String key = '${sp.partQuality}_${sp.price}_${sp.supplierName}'.toUpperCase();
            uniquePrices[key] = sp;
          }
        }
      }

      List<SupplierPrice> finalPrices = uniquePrices.values.toList();
      // ترتيب القائمة من الأرخص للأغلى
      finalPrices.sort((a, b) => a.price.compareTo(b.price));

      currentSuggestedPrices = finalPrices;
      notifyListeners();
      
    } catch (e) {
      debugPrint("Error fetching prices locally: $e");
      currentSuggestedPrices = [];
      notifyListeners();
    }
  }

  // دالة لتفريغ الأسعار فوراً عند تغيير الموديل
  void clearSuggestedPrices() {
    currentSuggestedPrices.clear();
    notifyListeners();
  }

  // -----------------------------------------------------------------
  // إدارة التذاكر والعمليات
  // -----------------------------------------------------------------

  Future<DeviceBrand> addBrand(String brandName) async {
    final newBrand = DeviceBrand()..name = brandName.toUpperCase().trim()..models = [];
    await IsarService.db.writeTxn(() async => await IsarService.db.deviceBrands.put(newBrand));
    brands.add(newBrand);
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

  Future<void> addTicket(MaintenanceTicket ticket) async {
    await IsarService.db.writeTxn(() async {
      await IsarService.db.maintenanceTickets.put(ticket);
    });
    
    final existingIndex = tickets.indexWhere((t) => t.firebaseId == ticket.firebaseId);
    if (existingIndex == -1) tickets.insert(0, ticket);
    notifyListeners();

    await _syncTicketToFirebase(ticket);
  }

  Future<void> updateTicketStatus(MaintenanceTicket ticket, String newStatus, {bool archive = false}) async {
    ticket.status = newStatus;
    if (archive) {
      ticket.isArchived = true;
    }
    
    // المزامنة المالية مع نظام POS عند التسليم
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
      } catch (e) {
        debugPrint("فشلت مزامنة POS اللحظية، سيتم الاعتماد على الكاش.");
      }
    }

    await IsarService.db.writeTxn(() async {
      await IsarService.db.maintenanceTickets.put(ticket);
    });
    
    if (archive) {
      tickets.removeWhere((t) => t.firebaseId == ticket.firebaseId);
    }
    notifyListeners();

    await _syncTicketToFirebase(ticket);
  }

  // -----------------------------------------------------------------
  // إدارة المخزون
  // -----------------------------------------------------------------

  Future<void> addInventoryPart(LocalPart part) async {
    await IsarService.db.writeTxn(() async {
      await IsarService.db.localParts.put(part);
    });
    inventory.add(part);
    notifyListeners();
  }

  Future<bool> deductPartFromInventory(LocalPart part) async {
    if (part.quantity <= 0) return false;
    part.quantity -= 1;
    await IsarService.db.writeTxn(() async {
      await IsarService.db.localParts.put(part);
    });
    notifyListeners();
    return true;
  }

  Future<bool> usePartForTicket(MaintenanceTicket ticket, LocalPart part) async {
    if (part.quantity <= 0) return false;
    part.quantity -= 1;
    ticket.netProfit = ticket.finalCost - part.costPrice;

    await IsarService.db.writeTxn(() async {
      await IsarService.db.localParts.put(part);
      await IsarService.db.maintenanceTickets.put(ticket);
    });

    notifyListeners();
    await _syncTicketToFirebase(ticket);
    return true;
  }

  // -----------------------------------------------------------------
  // الإعدادات والتقارير
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
      final allTickets = await IsarService.db.maintenanceTickets.where().findAll();
      final currentMonthTickets = allTickets.where((t) {
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
      return false;
    }
  }
}