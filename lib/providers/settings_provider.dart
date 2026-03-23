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
import '../models/app_models.dart';
import '../services/isar_service.dart';
import 'package:isar/isar.dart';

class SettingsProvider extends ChangeNotifier {
  String telegramBotToken = '';
  String telegramChatId = '';
  String printerMac = '';
  
  bool autoCleanupEnabled = false;
  int autoCleanupDays = 90;

  SettingsProvider() {
    _loadSettings();
  }

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

  // توليد تقرير PDF احترافي ومنسق
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
    
    // تحميل الخطوط العربية المخصصة (تأكد من وجودها في assets/fonts)
    pw.Font arabicFont;
    pw.Font arabicFontBold;
    try {
      final fontData = await rootBundle.load("assets/fonts/Cairo-Regular.ttf");
      arabicFont = pw.Font.ttf(fontData);
      final fontDataBold = await rootBundle.load("assets/fonts/Cairo-Bold.ttf");
      arabicFontBold = pw.Font.ttf(fontDataBold);
    } catch (e) {
      // في حال عدم وجود الخط، استخدام خط افتراضي لتجنب انهيار التطبيق
      arabicFont = pw.Font.helvetica();
      arabicFontBold = pw.Font.helveticaBold();
    }

    String reportDateStr = '$targetMonth / $targetYear';

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        textDirection: pw.TextDirection.rtl, // تحديد اتجاه النص للعربية
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        header: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Text(shopName, style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 4),
            pw.Text('التقرير الشهري المالي والتشغيلي', style: const pw.TextStyle(fontSize: 18, color: PdfColors.grey700)),
            pw.SizedBox(height: 4),
            pw.Text('عن شهر: $reportDateStr', style: const pw.TextStyle(fontSize: 14, color: PdfColors.grey600)),
            pw.Divider(thickness: 2, color: PdfColors.blueGrey900),
            pw.SizedBox(height: 20),
          ]
        ),
        footer: (context) => pw.Container(
          alignment: pw.Alignment.center,
          margin: const pw.EdgeInsets.only(top: 10),
          child: pw.Text('صفحة ${context.pageNumber} من ${context.pagesCount} - تم توليد التقرير بواسطة النظام', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
        ),
        build: (context) => [
          // الملصقات الإحصائية (Summary)
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryBox('إجمالي الأجهزة', '${targetTickets.length}', PdfColors.blueGrey800),
              _buildSummaryBox('الإيرادات (د.أ)', totalRevenue.toStringAsFixed(2), PdfColors.blue800),
              _buildSummaryBox('صافي الربح (د.أ)', totalProfit.toStringAsFixed(2), PdfColors.green800),
            ]
          ),
          pw.SizedBox(height: 30),
          
          // جدول التذاكر
          pw.TableHelper.fromTextArray(
            headers: ['رقم', 'تاريخ الاستلام', 'العميل', 'الموديل', 'الحالة', 'الإيراد', 'الربح'],
            data: targetTickets.asMap().entries.map((entry) {
              int idx = entry.key + 1;
              var t = entry.value;
              String dateOnly = t.receivedDate.length >= 10 ? t.receivedDate.substring(0, 10) : t.receivedDate;
              return [
                idx.toString(),
                dateOnly,
                t.customerName,
                t.deviceModel,
                t.status == 'Delivered' ? 'سلم' : t.status,
                t.finalCost.toString(),
                t.netProfit.toString(),
              ];
            }).toList(),
            border: pw.TableBorder.all(color: PdfColors.grey300, width: 1),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white, fontSize: 10),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey800),
            cellStyle: const pw.TextStyle(fontSize: 10),
            cellAlignment: pw.Alignment.center,
            cellPadding: const pw.EdgeInsets.all(6),
            oddRowDecoration: const pw.BoxDecoration(color: PdfColors.grey100),
          ),
        ],
      ),
    );

    return await pdf.save();
  }

  pw.Widget _buildSummaryBox(String title, String value, PdfColor color) {
    return pw.Container(
      width: 140,
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColor(color.red, color.green, color.blue, 0.1),
        border: pw.Border.all(color: color, width: 1.5),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Text(title, style: pw.TextStyle(fontSize: 12, color: color, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 4),
          pw.Text(value, style: pw.TextStyle(fontSize: 18, color: color, fontWeight: pw.FontWeight.bold)),
        ]
      )
    );
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
}