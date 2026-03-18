import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/app_models.dart';

class IsarService {
  static late Isar db;

  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    db = await Isar.open(
      [
        MaintenanceTicketSchema, 
        LocalPartSchema, 
        AppSettingSchema,
        DeviceBrandSchema,   // تمت إضافة جدول الشركات والموديلات
        QuickPriceSchema,    // تمت إضافة جدول الأسعار السريعة
        SupplierPriceSchema  // تمت إضافة جدول أسعار الموردين
      ],
      directory: dir.path,
    );
  }

  static Future<String?> getSetting(String key) async {
    final setting = await db.appSettings.where().keyEqualTo(key).findFirst();
    return setting?.value;
  }

  static Future<void> saveSetting(String key, String value) async {
    final setting = await db.appSettings.where().keyEqualTo(key).findFirst() ?? AppSetting()..key = key;
    setting.value = value;
    await db.writeTxn(() async {
      await db.appSettings.put(setting);
    });
  }
}