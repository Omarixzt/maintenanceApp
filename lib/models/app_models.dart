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
  String? expectedDeliveryDate;
  double expectedCost = 0.0;
  double finalCost = 0.0;
  double netProfit = 0.0;
  
  String? imagePath;      
  String? imagePathAfter; 
  
  String imei = '';
  int syncStatus = 0; 
  
  bool isArchived = false;

  // الحقل الجديد لحل التضارب: يخزن وقت آخر تعديل بالميللي ثانية
  int updatedAt = DateTime.now().millisecondsSinceEpoch;

  Map<String, dynamic> toMap() {
    return {
      'firebaseId': firebaseId,
      'customerName': customerName,
      'phoneNumber': phoneNumber,
      'deviceType': deviceType,
      'deviceModel': deviceModel,
      'faultDescription': faultDescription,
      'status': status,
      'receivedDate': receivedDate,
      'expectedDeliveryDate': expectedDeliveryDate,
      'expectedCost': expectedCost,
      'finalCost': finalCost,
      'netProfit': netProfit,
      'imagePath': imagePath,
      'imagePathAfter': imagePathAfter, 
      'imei': imei,
      'syncStatus': syncStatus,
      'isArchived': isArchived,
      'updatedAt': updatedAt, // إرسال وقت التعديل إلى السحابة
    };
  }

  static MaintenanceTicket fromMap(Map<String, dynamic> map) {
    return MaintenanceTicket()
      ..firebaseId = map['firebaseId'] as String?
      ..customerName = map['customerName'] as String? ?? ''
      ..phoneNumber = map['phoneNumber'] as String? ?? ''
      ..deviceType = map['deviceType'] as String? ?? ''
      ..deviceModel = map['deviceModel'] as String? ?? ''
      ..faultDescription = map['faultDescription'] as String? ?? ''
      ..status = map['status'] as String? ?? 'Waiting'
      ..receivedDate = map['receivedDate'] as String? ?? ''
      ..expectedDeliveryDate = map['expectedDeliveryDate'] as String?
      ..expectedCost = (map['expectedCost'] ?? 0.0).toDouble()
      ..finalCost = (map['finalCost'] ?? 0.0).toDouble()
      ..netProfit = (map['netProfit'] ?? 0.0).toDouble()
      ..imagePath = map['imagePath'] as String?
      ..imagePathAfter = map['imagePathAfter'] as String? 
      ..imei = map['imei'] as String? ?? ''
      ..syncStatus = map['syncStatus'] as int? ?? 0
      ..isArchived = map['isArchived'] as bool? ?? false
      ..updatedAt = map['updatedAt'] as int? ?? 0; // استلام وقت التعديل من السحابة
  }
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
  String supplierName = '';
  @Index()
  String deviceBrand = '';
  @Index()
  String deviceModel = '';
  String partQuality = '';
  double price = 0.0;

  static SupplierPrice fromMap(Map<String, dynamic> map) {
    return SupplierPrice()
      ..supplierName = map['supplierName']?.toString() ?? ''
      ..deviceBrand = map['deviceBrand']?.toString() ?? ''
      ..deviceModel = map['deviceModel']?.toString() ?? ''
      ..partQuality = map['partQuality']?.toString() ?? ''
      ..price = double.tryParse(map['price']?.toString() ?? '0') ?? 0.0;
  }

  Map<String, dynamic> toMap() {
    return {
      'supplierName': supplierName,
      'deviceBrand': deviceBrand,
      'deviceModel': deviceModel,
      'partQuality': partQuality,
      'price': price,
    };
  }
}