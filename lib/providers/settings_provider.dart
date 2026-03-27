import 'dart:async'; 
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:isar/isar.dart';
import '../models/app_models.dart';
import '../services/isar_service.dart';

class SettingsProvider extends ChangeNotifier {
  String telegramBotToken = '';
  String telegramChatId = '';
  String printerMac = '';
  
  bool autoCleanupEnabled = false;
  int autoCleanupDays = 90;

  // ==========================================
  // متغيرات نظام الصلاحيات السحابية
  // ==========================================
  bool allowPriceSync = false;
  StreamSubscription<DocumentSnapshot>? _permissionSub;

  SettingsProvider() {
    _loadSettings();
    _listenToShopPermissions(); 
  }

  // ==========================================
  // دوال الصلاحيات (Feature Flags)
  // ==========================================
  void _listenToShopPermissions() async {
    String? shopId = await IsarService.getSetting('active_shop_id');
    if (shopId == null || shopId.isEmpty) return;

    _permissionSub?.cancel();
    _permissionSub = FirebaseFirestore.instance
        .collection('shop_permissions')
        .doc(shopId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        allowPriceSync = snapshot.data()?['allowPriceSync'] ?? false;
        notifyListeners(); 
      }
    });
  }

  Future<void> consumePriceSyncPermission() async {
    String? shopId = await IsarService.getSetting('active_shop_id');
    if (shopId == null) return;

    allowPriceSync = false;
    notifyListeners();

    try {
      await FirebaseFirestore.instance
          .collection('shop_permissions')
          .doc(shopId)
          .set({'allowPriceSync': false}, SetOptions(merge: true));
    } catch (e) {
      debugPrint("خطأ في تحديث الصلاحية: $e");
    }
  }

  // ==========================================
  // دوال الإعدادات والتنظيف 
  // ==========================================
  Future<void> _loadSettings() async {
    telegramBotToken = await IsarService.getSetting('bot_token') ?? '';
    telegramChatId = await IsarService.getSetting('chat_id') ?? '';
    printerMac = await IsarService.getSetting('printer_mac') ?? '';
    
    String? cleanupEnabledStr = await IsarService.getSetting('auto_cleanup_enabled');
    autoCleanupEnabled = cleanupEnabledStr == 'true';

    String? cleanupDaysStr = await IsarService.getSetting('auto_cleanup_days');
    autoCleanupDays = int.tryParse(cleanupDaysStr ?? '90') ?? 90;

    if (autoCleanupEnabled) cleanupOldImages();
    notifyListeners();
  }

  Future<void> saveSettings(String token, String chat, String mac) async {
    telegramBotToken = token;
    telegramChatId = chat;
    printerMac = mac;
    await IsarService.saveSetting('bot_token', token);
    await IsarService.saveSetting('chat_id', chat);
    await IsarService.saveSetting('printer_mac', mac);
    notifyListeners();
  }

  Future<void> updateAutoCleanupSettings(bool enabled, int days) async {
    autoCleanupEnabled = enabled;
    autoCleanupDays = days;
    await IsarService.saveSetting('auto_cleanup_enabled', enabled.toString());
    await IsarService.saveSetting('auto_cleanup_days', days.toString());
    notifyListeners();
  }

  Future<int> cleanupOldImages({bool force = false}) async {
    if (!autoCleanupEnabled && !force) return 0;
    
    String? shopId = await IsarService.getSetting('active_shop_id');
    if (shopId == null || shopId.isEmpty) return 0;

    int deletedCount = 0;
    final isar = IsarService.db;
    final thresholdDate = DateTime.now().subtract(Duration(days: autoCleanupDays));
    
    final archivedTickets = await isar.maintenanceTickets
        .filter()
        .shopIdEqualTo(shopId) 
        .isArchivedEqualTo(true)
        .findAll();

    for (var ticket in archivedTickets) {
      try {
        DateTime received = DateTime.parse(ticket.receivedDate);
        if (received.isBefore(thresholdDate)) {
          bool updated = false;
          if (ticket.imagePath != null && ticket.imagePath!.isNotEmpty) {
            final file = File(ticket.imagePath!);
            if (await file.exists()) { await file.delete(); deletedCount++; }
            ticket.imagePath = null; 
            updated = true;
          }
          if (ticket.imagePathAfter != null && ticket.imagePathAfter!.isNotEmpty) {
            final file = File(ticket.imagePathAfter!);
            if (await file.exists()) { await file.delete(); deletedCount++; }
            ticket.imagePathAfter = null; 
            updated = true;
          }
          if (updated) {
            await isar.writeTxn(() async => await isar.maintenanceTickets.put(ticket));
          }
        }
      } catch (e) {
        debugPrint('خطأ في التنظيف: $e');
      }
    }
    if (deletedCount > 0) notifyListeners();
    return deletedCount;
  }

  // ==========================================
  // تصميم التقرير الشهري (PDF)
  // ==========================================
  Future<Uint8List> generateMonthlyReportPdf(int targetMonth, int targetYear) async {
    String? shopId = await IsarService.getSetting('active_shop_id');
    String shopName = await IsarService.getSetting('store_name') ?? 'صيانة البيك';
    
    final allTickets = await IsarService.db.maintenanceTickets
        .filter()
        .shopIdEqualTo(shopId ?? '')
        .findAll();
        
    final targetTickets = allTickets.where((t) {
      try {
        final d = DateTime.parse(t.receivedDate);
        return d.month == targetMonth && d.year == targetYear;
      } catch (_) { return false; }
    }).toList();

    double totalRevenue = 0;
    double totalProfit = 0;
    for (var t in targetTickets) {
      totalRevenue += t.finalCost;
      totalProfit += t.netProfit;
    }

    final pdf = pw.Document();
    
    pw.Font arabicFont;
    pw.Font arabicFontBold;
    try {
      arabicFont = await PdfGoogleFonts.cairoRegular();
      arabicFontBold = await PdfGoogleFonts.cairoBold();
    } catch (e) {
      try {
        final fontData = await rootBundle.load("assets/fonts/Cairo-Regular.ttf");
        arabicFont = pw.Font.ttf(fontData);
        final fontDataBold = await rootBundle.load("assets/fonts/Cairo-Bold.ttf");
        arabicFontBold = pw.Font.ttf(fontDataBold);
      } catch (_) {
        arabicFont = pw.Font.helvetica();
        arabicFontBold = pw.Font.helveticaBold();
      }
    }

    String reportDateStr = '$targetMonth / $targetYear';

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        textDirection: pw.TextDirection.rtl, 
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        header: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Text(shopName, style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold), textDirection: pw.TextDirection.rtl),
            pw.SizedBox(height: 4),
            pw.Text('التقرير الشهري لقسم الصيانة', style: const pw.TextStyle(fontSize: 18, color: PdfColors.grey700), textDirection: pw.TextDirection.rtl),
            pw.SizedBox(height: 4),
            pw.Directionality(
              textDirection: pw.TextDirection.rtl,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text('تقرير شهر: ', style: const pw.TextStyle(fontSize: 14, color: PdfColors.grey600)),
                  pw.Text(reportDateStr, style: const pw.TextStyle(fontSize: 14, color: PdfColors.grey600), textDirection: pw.TextDirection.ltr),
                ]
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Divider(thickness: 2, color: PdfColors.blueGrey900),
            pw.SizedBox(height: 20),
          ]
        ),
        footer: (context) => pw.Directionality(
          textDirection: pw.TextDirection.rtl,
          child: pw.Container(
            alignment: pw.Alignment.center,
            margin: const pw.EdgeInsets.only(top: 10),
            child: pw.Text('صفحة ${context.pageNumber} من ${context.pagesCount} - تم توليد التقرير بواسطة نظام الصيانة', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
          ),
        ),
        build: (context) => [
          // إجمالي المبالغ كسطر نصي بدلاً من المربعات
          pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 20),
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                border: pw.Border.all(color: PdfColors.grey300),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                children: [
                  pw.Text('إجمالي الأجهزة: ${targetTickets.length}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('إجمالي الإيرادات: ${totalRevenue.toStringAsFixed(2)} د.أ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
                  pw.Text('صافي الأرباح: ${totalProfit.toStringAsFixed(2)} د.أ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.green800)),
                ]
              )
            )
          ),
          
          // جدول التذاكر
          pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.TableHelper.fromTextArray(
              headers: ['الربح', 'الإيراد', 'الحالة', 'النوع والموديل', 'العميل', 'تاريخ الاستلام', 'رقم'],
              data: targetTickets.asMap().entries.map((entry) {
                int idx = entry.key + 1;
                var t = entry.value;
                String dateOnly = t.receivedDate.length >= 10 ? t.receivedDate.substring(0, 10) : t.receivedDate;
                
                String statusAr = t.status;
                if (t.status == 'Delivered') statusAr = 'تم التسليم';
                if (t.status == 'Ready') statusAr = 'جاهز';
                if (t.status == 'Waiting') statusAr = 'انتظار';
                if (t.status == 'In Progress') statusAr = 'جاري العمل';

                return [
                  t.netProfit.toString(),
                  t.finalCost.toString(),
                  statusAr,
                  '${t.deviceType} ${t.deviceModel}', 
                  t.customerName,
                  dateOnly,
                  idx.toString(),
                ];
              }).toList(),
              border: pw.TableBorder.all(color: PdfColors.grey300, width: 1),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white, fontSize: 11),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey800),
              cellStyle: const pw.TextStyle(fontSize: 10),
              cellAlignment: pw.Alignment.centerRight, 
              cellPadding: const pw.EdgeInsets.all(6),
              oddRowDecoration: const pw.BoxDecoration(color: PdfColors.grey100),
            ),
          ),
        ],
      ),
    );

    return await pdf.save();
  }

  // حفظ التقرير في الجهاز ومشاركته
  Future<void> shareReportPdf(int month, int year) async {
    try {
      final pdfBytes = await generateMonthlyReportPdf(month, year);
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/Report_${month}_$year.pdf').create();
      await file.writeAsBytes(pdfBytes);
      await Share.shareXFiles([XFile(file.path)], text: 'التقرير المالي لشهر $month / $year');
    } catch (e) {
      debugPrint('خطأ في مشاركة التقرير: $e');
    }
  }

  // إرسال التقرير لتيليجرام
  Future<bool> sendReportPdfToTelegram(int month, int year) async {
    if (telegramBotToken.isEmpty || telegramChatId.isEmpty) return false;
    try {
      final pdfBytes = await generateMonthlyReportPdf(month, year);
      
      var request = http.MultipartRequest('POST', Uri.parse('https://api.telegram.org/bot$telegramBotToken/sendDocument'));
      request.fields['chat_id'] = telegramChatId;
      request.fields['caption'] = 'التقرير المالي والتشغيلي لشهر $month / $year';
      request.files.add(http.MultipartFile.fromBytes('document', pdfBytes, filename: 'Report_${month}_$year.pdf'));
      
      var response = await request.send();
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('خطأ في إرسال تيليجرام: $e');
      return false;
    }
  }

  @override
  void dispose() {
    _permissionSub?.cancel(); 
    super.dispose();
  }
}