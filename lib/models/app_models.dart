import 'package:isar/isar.dart';

part 'app_models.g.dart';

@collection
class MaintenanceTicket {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  String? firebaseId;

  String customerName = '';
  String phoneNumber = '';
  String deviceType = '';
  String deviceModel = '';
  String faultDescription = '';
  String status = 'Waiting'; 
  String receivedDate = ''; 
  double expectedCost = 0.0;
  double finalCost = 0.0;
  double netProfit = 0.0;
  String? imagePath;
  String imei = '';
  int syncStatus = 0; 
}

@collection
class LocalPart {
  Id isarId = Isar.autoIncrement;
  
  @Index(unique: true)
  String? partId;
  
  String partName = '';
  double costPrice = 0.0;
  int quantity = 0;
}

@collection
class AppSetting {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  String? key;
  
  String? value;
}

@collection
class DeviceBrand {
  Id isarId = Isar.autoIncrement;
  @Index(unique: true)
  String name = '';
  List<String> models = []; 
}

@collection
class QuickPrice {
  Id isarId = Isar.autoIncrement;
  int indexId = 0; 
  double price = 0.0;
}

@collection
class SupplierPrice {
  Id isarId = Isar.autoIncrement;
  
  @Index()
  String supplierName = ''; // مثال: 'التنين', 'مؤسسة ورد'
  
  @Index()
  String deviceBrand = ''; // مثال: 'TECNO', 'SAMSUNG'
  
  @Index()
  String deviceModel = ''; // مثال: 'SPARK 6'
  
  String partQuality = ''; // مثال: 'أصلي', 'جودة عالية INCELL'
  double price = 0.0;
}