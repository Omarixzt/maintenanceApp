import 'dart:typed_data';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:intl/intl.dart';
import '../models/app_models.dart';
import '../theme/app_theme.dart';

class PrinterService {
  static final BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  /// الدالة المطورة للطباعة الاحترافية
  static Future<Map<String, dynamic>> printProfessionalTicket({
    required MaintenanceTicket ticket,
    required String macAddress,
    bool isDelivery = false,
  }) async {
    if (macAddress.isEmpty) {
      return {'success': false, 'message': 'عنوان الطابعة غير مضبوط في الإعدادات'};
    }

    try {
      // 1. التحقق من الاتصال وتوفير الطاقة
      bool? isConnected = await bluetooth.isConnected;
      if (isConnected == false) {
        await bluetooth.connect(BluetoothDevice('Printer', macAddress));
      }

      // 2. إعداد البيانات الأساسية
      String shopName = "ALBAIK MAINTENANCE";
      String dateStr = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
      String ticketId = ticket.firebaseId?.substring(0, 8).toUpperCase() ?? 'N/A';

      // 3. بدء عملية الطباعة بتنسيقات متقدمة
      // ---------------------------------------------
      // Header: الشعار واسم المحل
      bluetooth.printCustom(shopName, 3, 1); // حجم كبير، مركز
      bluetooth.printCustom("Irbid - Jordan", 1, 1);
      bluetooth.printNewLine();

      // معلومات التذكرة
      bluetooth.printLeftRight("TICKET ID:", "#$ticketId", 1);
      bluetooth.printLeftRight("DATE:", dateStr, 1);
      bluetooth.printCustom("--------------------------------", 1, 1);

      // نوع الوصل
      String typeLabel = isDelivery ? "DELIVERY RECEIPT" : "INTAKE RECEIPT";
      bluetooth.printCustom(typeLabel, 2, 1); // حجم متوسط
      bluetooth.printNewLine();

      // بيانات العميل والجهاز
      bluetooth.printLeftRight("CUSTOMER:", ticket.customerName.toUpperCase(), 1);
      bluetooth.printLeftRight("PHONE:", ticket.phoneNumber, 1);
      bluetooth.printNewLine();
      
      bluetooth.printCustom("DEVICE INFO:", 1, 0);
      bluetooth.printCustom("${ticket.deviceType} - ${ticket.deviceModel}", 1, 0);
      
      bluetooth.printCustom("FAULT DESCRIPTION:", 1, 0);
      bluetooth.printCustom(ticket.faultDescription, 0, 0); // خط أصغر للوصف الطويل
      
      bluetooth.printCustom("--------------------------------", 1, 1);

      // التكلفة المالية
      if (isDelivery) {
        bluetooth.printLeftRight("TOTAL PAID:", "${ticket.finalCost} JOD", 2);
      } else {
        bluetooth.printLeftRight("EXPECTED COST:", "${ticket.expectedCost} JOD", 1);
      }

      bluetooth.printNewLine();

      // 4. إضافة QR Code لتسهيل تتبع الجهاز لاحقاً
      // طباعة الـ ID كـ QR لعمل Scan سريع في الورشة
      if (ticket.firebaseId != null) {
        bluetooth.printQRcode(ticket.firebaseId!, 200, 200, 1);
      }

      // 5. تذييل الفاتورة
      bluetooth.printNewLine();
      bluetooth.printCustom("WARRANTY: 30 DAYS ON REPAIRS", 1, 1);
      bluetooth.printCustom("Thank you for your trust!", 1, 1);
      
      // التغذية والقطع
      bluetooth.printNewLine();
      bluetooth.printNewLine();
      bluetooth.paperCut();

      return {'success': true, 'message': 'تمت الطباعة بنجاح'};
    } catch (e) {
      return {'success': false, 'message': 'خطأ في الاتصال بالطابعة: $e'};
    }
  }

  /// دالة لاختبار الطابعة فقط (Self Test)
  static Future<void> testPrinter(String macAddress) async {
    if (await bluetooth.isConnected == false) {
      await bluetooth.connect(BluetoothDevice('Test', macAddress));
    }
    bluetooth.printCustom("PRINTER TEST SUCCESSFUL", 2, 1);
    bluetooth.printNewLine();
    bluetooth.paperCut();
  }
}