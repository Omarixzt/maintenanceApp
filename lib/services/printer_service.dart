import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:image/image.dart' as img_pkg;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/app_models.dart';
import 'isar_service.dart';
import '../theme/app_theme.dart'; 

class PrinterService {
  static const double paperWidth = 384.0;

  static Future<ui.Image?> _loadUiLogo() async {
    try {
      String? customPath = await IsarService.getSetting('store_logo_path');
      if (customPath != null && customPath.isNotEmpty) {
        final File imgFile = File(customPath);
        if (imgFile.existsSync()) {
          final Uint8List bytes = await imgFile.readAsBytes();
          return await decodeImageFromList(bytes);
        }
      }
      final ByteData data = await rootBundle.load('logo.png');
      final Uint8List bytes = data.buffer.asUint8List();
      return await decodeImageFromList(bytes);
    } catch (e) {
      debugPrint('تحذير: لم يتم العثور على الشعار');
      return null;
    }
  }

  static Future<Uint8List> _generateReceiptImageAsBytes(MaintenanceTicket ticket, bool isCustomerCopy) async {
    String dateStr = DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.now());
    
    String expectedDelivery = ticket.expectedDeliveryDate != null 
        ? DateFormat('yyyy-MM-dd').format(DateTime.parse(ticket.expectedDeliveryDate!)) 
        : DateFormat('yyyy-MM-dd').format(DateTime.now().add(const Duration(days: 3)));

    String storeName = await IsarService.getSetting('store_name') ?? 'صيانة البيك';
    String storeAddress = await IsarService.getSetting('store_address') ?? 'إربد - الأردن';
    String storePhone = await IsarService.getSetting('store_phone') ?? '+962 7X XXX XXXX';

    String? layoutJson = await IsarService.getSetting('receipt_layout');
    List<dynamic> layout = layoutJson != null && layoutJson.isNotEmpty ? jsonDecode(layoutJson) : _getDefaultLayout();

    double currentY = 10.0;
    List<Function(Canvas)> drawCalls = [];

    void drawText(String text, {double fontSize = 22, bool isBold = false, TextAlign align = TextAlign.right}) {
      final span = TextSpan(
        text: text,
        style: TextStyle(
          color: Colors.black,
          fontSize: fontSize,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          fontFamily: 'Cairo', 
        ),
      );
      final tp = TextPainter(text: span, textDirection: ui.TextDirection.rtl, textAlign: align);
      tp.layout(maxWidth: paperWidth - 20);

      double x = 10;
      if (align == TextAlign.center) {
        x = (paperWidth - tp.width) / 2;
      } else if (align == TextAlign.left) {
        x = 10;
      } else {
        x = paperWidth - tp.width - 10;
      }

      final y = currentY;
      drawCalls.add((canvas) => tp.paint(canvas, Offset(x, y)));
      currentY += tp.height + 8;
    }

    void drawDivider() {
      currentY += 10;
      final y = currentY;
      drawCalls.add((canvas) {
        canvas.drawLine(Offset(20, y), Offset(paperWidth - 20, y), Paint()..color = Colors.black..strokeWidth = 2);
      });
      currentY += 20;
    }

    for (var item in layout) {
      // قراءة التفضيلات المخصصة لكل نوع وصل (للتوافق مع التعديلات الجديدة)
      bool enabledForCustomer = item['isEnabledCustomer'] ?? item['isEnabled'] ?? true;
      bool enabledForDevice = item['isEnabledDevice'] ?? item['isEnabled'] ?? true;

      if (isCustomerCopy && !enabledForCustomer) continue;
      if (!isCustomerCopy && !enabledForDevice) continue;

      if (item['isCustom'] == true) {
        String customText = item['customText'] ?? '';
        if (customText.isNotEmpty) {
          drawText(customText, align: TextAlign.center, isBold: true);
          drawDivider();
        }
        continue;
      }

      switch (item['id']) {
        case 'logo':
          ui.Image? logo = await _loadUiLogo();
          if (logo != null) {
            final logoY = currentY;
            final scaledWidth = 250.0;
            final scaledHeight = (logo.height / logo.width) * scaledWidth;
            final logoX = (paperWidth - scaledWidth) / 2;
            
            drawCalls.add((canvas) {
              paintImage(canvas: canvas, rect: Rect.fromLTWH(logoX, logoY, scaledWidth, scaledHeight), image: logo, fit: BoxFit.contain);
            });
            currentY += scaledHeight + 15;
          }
          break;
        case 'header':
          drawText(storeName, align: TextAlign.center, isBold: true, fontSize: 32);
          drawText(storeAddress, align: TextAlign.center, fontSize: 24);
          drawDivider();
          break;
        case 'ticket_info':
          drawText("رقم الوصل: #${ticket.isarId}", isBold: true);
          drawText("التاريخ: $dateStr");
          drawDivider();
          break;
        case 'delivery':
          drawText("تاريخ التسليم المتوقع:");
          drawText(expectedDelivery, isBold: true, align: TextAlign.center);
          drawDivider();
          break;
        case 'customer':
          drawText("معلومات الزبون:", isBold: true);
          drawText("الاسم: ${ticket.customerName}");
          drawText("الهاتف: ${ticket.phoneNumber}");
          drawDivider();
          break;
        case 'device':
          drawText("معلومات الجهاز:", isBold: true);
          drawText("${ticket.deviceType} - ${ticket.deviceModel}");
          currentY += 10;
          drawText("وصف العطل:", isBold: true);
          drawText(ticket.faultDescription);
          drawDivider();
          break;
        case 'cost':
          drawText("التكلفة المتوقعة: ${ticket.expectedCost} دينار", align: TextAlign.center, isBold: true, fontSize: 26);
          drawDivider();
          break;
        case 'footer':
          drawText("للتواصل: $storePhone", align: TextAlign.center);
          currentY += 10;
          drawText(isCustomerCopy ? "*** نسخة الزبون ***" : "*** ملصق الجهاز ***", align: TextAlign.center, isBold: true);
          break;
      }
    }

    currentY += 80;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.drawRect(Rect.fromLTWH(0, 0, paperWidth, currentY), Paint()..color = Colors.white);
    
    for (var call in drawCalls) { call(canvas); }

    final picture = recorder.endRecording();
    final img = await picture.toImage(paperWidth.toInt(), currentY.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  static Future<Map<String, dynamic>> printProfessionalTicket({
    required MaintenanceTicket ticket,
    required String macAddress,
    required bool isCustomerCopy,
  }) async {
    Uint8List receiptImageBytes = await _generateReceiptImageAsBytes(ticket, isCustomerCopy);

    if (macAddress.isEmpty) {
      return {'success': false, 'message': 'عنوان الطابعة غير مضبوط', 'imageBytes': receiptImageBytes, 'ticketId': ticket.isarId.toString()};
    }

    try {
      bool isConnected = await PrintBluetoothThermal.connectionStatus;
      if (!isConnected) {
        bool connected = await PrintBluetoothThermal.connect(macPrinterAddress: macAddress);
        if (!connected) return {'success': false, 'message': 'فشل الاتصال بالطابعة. تأكد من تشغيلها.', 'imageBytes': receiptImageBytes, 'ticketId': ticket.isarId.toString()};
      }

      final profile = await CapabilityProfile.load();
      final generator = Generator(PaperSize.mm58, profile); 
      List<int> bytes = [];

      final decodedImg = img_pkg.decodeImage(receiptImageBytes);
      if (decodedImg != null) bytes.addAll(generator.imageRaster(decodedImg));

      await PrintBluetoothThermal.writeBytes(bytes);
      return {'success': true, 'message': 'تمت الطباعة بنجاح', 'serialNumber': ticket.isarId, 'imageBytes': receiptImageBytes};
    } catch (e) {
      return {'success': false, 'message': 'حدث خطأ: $e', 'imageBytes': receiptImageBytes, 'ticketId': ticket.isarId.toString()};
    }
  }

  static Future<void> printWithFallbackDialog({
    required BuildContext context,
    required MaintenanceTicket ticket,
    required String macAddress,
    required bool isCustomerCopy,
  }) async {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('جاري معالجة الفاتورة...')));
    
    var result = await printProfessionalTicket(
      ticket: ticket,
      macAddress: macAddress,
      isCustomerCopy: isCustomerCopy,
    );

    if (!context.mounted) return;

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تمت الطباعة بنجاح - وصل #${result['serialNumber']}'), backgroundColor: Colors.green),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.print_disabled, color: AppTheme.albaikRichRed),
              SizedBox(width: 8),
              Text('تعذر الطباعة', style: TextStyle(color: AppTheme.albaikRichRed, fontWeight: FontWeight.bold)),
            ],
          ),
          content: Text('${result['message']}\n\nهل تريد مشاركة الفاتورة أو حفظها كصورة في جهازك؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx), 
              child: const Text('إلغاء', style: TextStyle(color: Colors.grey))
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.share),
              label: const Text('مشاركة / حفظ'),
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.albaikDeepNavy),
              onPressed: () async {
                Navigator.pop(ctx);
                await shareReceiptImage(result['imageBytes'], ticket.isarId.toString());
              },
            )
          ],
        ),
      );
    }
  }

  static Future<void> generateAndShareReceiptDirectly({
    required BuildContext context,
    required MaintenanceTicket ticket,
    required bool isCustomerCopy,
  }) async {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('جاري تجهيز الفاتورة كصورة...')));
    try {
      Uint8List imageBytes = await _generateReceiptImageAsBytes(ticket, isCustomerCopy);
      await shareReceiptImage(imageBytes, ticket.isarId.toString());
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل تجهيز الصورة: $e'), backgroundColor: Colors.red)
        );
      }
    }
  }

  static Future<void> shareReceiptImage(Uint8List imageBytes, String ticketId) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/receipt_$ticketId.png').create();
      await file.writeAsBytes(imageBytes);
      await Share.shareXFiles([XFile(file.path)], text: 'فاتورة صيانة - وصل رقم $ticketId');
    } catch (e) {
      debugPrint('خطأ في مشاركة الصورة: $e');
    }
  }

  static List<Map<String, dynamic>> _getDefaultLayout() {
    return [
      {'id': 'logo', 'isEnabledCustomer': true, 'isEnabledDevice': false, 'isCustom': false},
      {'id': 'header', 'isEnabledCustomer': true, 'isEnabledDevice': true, 'isCustom': false},
      {'id': 'ticket_info', 'isEnabledCustomer': true, 'isEnabledDevice': true, 'isCustom': false},
      {'id': 'delivery', 'isEnabledCustomer': true, 'isEnabledDevice': false, 'isCustom': false},
      {'id': 'customer', 'isEnabledCustomer': true, 'isEnabledDevice': true, 'isCustom': false},
      {'id': 'device', 'isEnabledCustomer': true, 'isEnabledDevice': true, 'isCustom': false},
      {'id': 'cost', 'isEnabledCustomer': true, 'isEnabledDevice': false, 'isCustom': false},
      {'id': 'footer', 'isEnabledCustomer': true, 'isEnabledDevice': false, 'isCustom': false},
    ];
  }

  static Future<void> testPrinter(String macAddress) async {
    try {
      bool isConnected = await PrintBluetoothThermal.connectionStatus;
      if (!isConnected) await PrintBluetoothThermal.connect(macPrinterAddress: macAddress);

      final profile = await CapabilityProfile.load();
      final generator = Generator(PaperSize.mm58, profile);
      List<int> bytes = [];

      bytes.addAll(generator.text("PRINTER TEST SUCCESSFUL", styles: const PosStyles(align: PosAlign.center, bold: true)));
      bytes.addAll(generator.emptyLines(3));
      
      await PrintBluetoothThermal.writeBytes(bytes);
    } catch (e) {
      debugPrint("خطأ في اختبار الطابعة: $e");
    }
  }
}