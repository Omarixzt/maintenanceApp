import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_models.dart';

class PrinterService {
  static final BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  /// قراءة الشعار من ملف الأصول (تأكد من وجود المسار في pubspec.yaml)
  static Future<Uint8List?> _loadLogo() async {
    try {
      final ByteData data = await rootBundle.load('logo.png');
      return data.buffer.asUint8List();
    } catch (e) {
      print('تحذير: لم يتم العثور على شعار في المسار logo.png');
      return null;
    }
  }

  /// الحصول على الرقم التسلسلي المحلي وتحديثه
  static Future<int> _getNextSerialNumber() async {
    final prefs = await SharedPreferences.getInstance();
    int current = prefs.getInt('serial_number') ?? 0;
    int next = current + 1;
    await prefs.setInt('serial_number', next);
    return next;
  }

  /// الدالة الأساسية للطباعة الاحترافية
  static Future<Map<String, dynamic>> printProfessionalTicket({
    required MaintenanceTicket ticket,
    required String macAddress,
    required bool isCustomerCopy,
  }) async {
    if (macAddress.isEmpty) {
      return {'success': false, 'message': 'عنوان الطابعة غير مضبوط في الإعدادات'};
    }

    try {
      bool? isConnected = await bluetooth.isConnected;
      if (isConnected == false) {
        await bluetooth.connect(BluetoothDevice('Printer', macAddress));
      }

      String shopName = "ALBAIK MAINTENANCE";
      String dateStr = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
      String ticketId = ticket.firebaseId?.substring(0, 8).toUpperCase() ?? 'N/A';
      int serialNumber = await _getNextSerialNumber();
      Uint8List? logoBytes = await _loadLogo();

      // --- بدء أوامر الطباعة ---
      if (logoBytes != null) {
        bluetooth.printImageBytes(logoBytes);
        bluetooth.printNewLine();
      }

      bluetooth.printCustom(shopName, 3, 1);
      bluetooth.printCustom("Irbid - Jordan", 1, 1);
      bluetooth.printNewLine();
      bluetooth.printCustom("========================================", 1, 1);

      bluetooth.printLeftRight("TICKET ID:", "#$ticketId", 1);
      bluetooth.printLeftRight("DATE:", dateStr, 1);
      
      if (isCustomerCopy) {
        bluetooth.printLeftRight("SERIAL NO:", "#$serialNumber", 1);
      }
      bluetooth.printCustom("----------------------------------------", 1, 1);

      // استخدام التاريخ من التذكرة إن وجد، وإلا إضافة 3 أيام افتراضية
      String expectedDelivery = ticket.expectedDeliveryDate ?? 
          DateFormat('yyyy-MM-dd').format(DateTime.now().add(const Duration(days: 3)));
      
      bluetooth.printLeftRight("EXPECTED DELIVERY:", expectedDelivery, 1);
      bluetooth.printCustom("========================================", 1, 1);

      bluetooth.printCustom("========================================", 1, 1);

      bluetooth.printLeftRight("CUSTOMER:", ticket.customerName.toUpperCase(), 1);
      bluetooth.printLeftRight("PHONE:", ticket.phoneNumber, 1);
      bluetooth.printNewLine();

      bluetooth.printCustom("DEVICE INFO:", 1, 0);
      bluetooth.printCustom("${ticket.deviceType} - ${ticket.deviceModel}", 1, 0);
      bluetooth.printNewLine();

      bluetooth.printCustom("FAULT DESCRIPTION:", 1, 0);
      bluetooth.printCustom(ticket.faultDescription, 0, 0);
      bluetooth.printNewLine();

      bluetooth.printCustom("----------------------------------------", 1, 1);

      // إضافة سعر التكلفة لكلا الوصلين
      bluetooth.printLeftRight("EXPECTED COST:", "${ticket.expectedCost} JOD", 1);
      bluetooth.printNewLine();

      // إزالة QR Code، ضمان 30 يوم، رسالة شكر وتعليمة للصق
      bluetooth.printCustom("========================================", 1, 1);
      bluetooth.printCustom("CONTACT: +962 7X XXX XXXX", 1, 1);
      
      if (isCustomerCopy) {
        bluetooth.printCustom("CUSTOMER COPY", 1, 1);
      } else {
        bluetooth.printCustom("DEVICE STICKER", 1, 1);
      }

      bluetooth.printNewLine();
      bluetooth.printNewLine();
      bluetooth.paperCut();

      return {'success': true, 'message': 'تمت الطباعة بنجاح', 'serialNumber': serialNumber};
    } catch (e) {
      return {'success': false, 'message': 'فشل الاتصال بالطابعة: $e'};
    }
  }

  /// دالة طباعة النسختين معاً
static Future<Map<String, dynamic>> printBothCopies({
    required MaintenanceTicket ticket,
    required String macAddress,
  }) async {
    // 1. طباعة نسخة العميل أولاً
    var customerResult = await printProfessionalTicket(
      ticket: ticket,
      macAddress: macAddress,
      isCustomerCopy: true,
    );

    if (!customerResult['success']) return customerResult;

    // 2. التحقق الفعلي من حالة الطابعة قبل إرسال الأمر الثاني
    try {
      bool? isConnected = await bluetooth.isConnected;
      if (isConnected == false) {
        await bluetooth.connect(BluetoothDevice('Printer', macAddress));
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'انقطع الاتصال بالطابعة قبل طباعة نسخة الجهاز: $e',
        'customerPrinted': true,
        'serialNumber': customerResult['serialNumber'],
      };
    }

    // 3. طباعة نسخة الجهاز
    var deviceResult = await printProfessionalTicket(
      ticket: ticket,
      macAddress: macAddress,
      isCustomerCopy: false,
    );

    if (!deviceResult['success']) {
      return {
        'success': false,
        'message': 'فشلت نسخة الجهاز: ${deviceResult['message']}',
        'customerPrinted': true,
        'serialNumber': customerResult['serialNumber'],
      };
    }

    return {
      'success': true,
      'message': 'تمت طباعة النسختين بنجاح',
      'serialNumber': customerResult['serialNumber'],
    };
  }
  
  /// إعادة محاولة الطباعة
  static Future<Map<String, dynamic>> retryPrint({
    required MaintenanceTicket ticket,
    required String macAddress,
    required bool isCustomerCopy,
  }) async {
    return await printProfessionalTicket(
      ticket: ticket,
      macAddress: macAddress,
      isCustomerCopy: isCustomerCopy,
    );
  }

  /// اختبار الطابعة
  static Future<void> testPrinter(String macAddress) async {
    try {
      if (await bluetooth.isConnected == false) {
        await bluetooth.connect(BluetoothDevice('Test', macAddress));
      }
      bluetooth.printCustom("ALBAIK MAINTENANCE", 3, 1);
      bluetooth.printCustom("PRINTER TEST SUCCESSFUL", 1, 1);
      bluetooth.printNewLine();
      bluetooth.paperCut();
    } catch (e) {
      print("خطأ في اختبار الطابعة: $e");
    }
  }
}