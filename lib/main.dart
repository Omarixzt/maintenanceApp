import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workmanager/workmanager.dart'; // <-- إضافة حزمة المزامنة بالخلفية
import 'package:isar/isar.dart'; // <-- إضافة Isar للتعامل مع الفلاتر في الخلفية
import 'firebase_options.dart';
import 'services/isar_service.dart';
import '../providers/ticket_provider.dart';
import '../providers/inventory_provider.dart';
import '../providers/settings_provider.dart';
import 'screens/main_navigation_screen.dart';
import 'theme/app_theme.dart';
import 'models/app_models.dart'; // <-- تأكد من المسار للوصول إلى MaintenanceTicket

// 1. الدالة المعزولة للعمل في الخلفية (يجب أن تكون خارج أي كلاس)
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      // تهيئة بيئة العمل المعزولة لأنها تعمل بمعزل عن واجهة التطبيق
      WidgetsFlutterBinding.ensureInitialized();
      await IsarService.init();
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      
      // جلب التذاكر المعلقة
      final pendingTickets = await IsarService.db.maintenanceTickets
          .filter()
          .syncStatusEqualTo(0)
          .findAll();

      if (pendingTickets.isEmpty) return Future.value(true);

      // رفع التذاكر للسحابة وتحديث حالتها محلياً
      for (var ticket in pendingTickets) {
        if (ticket.firebaseId != null && ticket.firebaseId!.isNotEmpty) {
          await FirebaseFirestore.instance
              .collection('maintenance_tickets')
              .doc(ticket.firebaseId)
              .set(ticket.toMap(), SetOptions(merge: true));
          
          ticket.syncStatus = 1; 
          await IsarService.db.writeTxn(() async {
            await IsarService.db.maintenanceTickets.put(ticket);
          });
        }
      }
      return Future.value(true);
    } catch (e) {
      debugPrint("Workmanager Sync Failed: $e");
      return Future.value(false); // في حال الفشل، سيعيد المحاولة لاحقاً
    }
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. تهيئة قاعدة البيانات المحلية Isar
  await IsarService.init();
  
  // 3. تهيئة فايربيس بشكل صحيح باستخدام المفاتيح التي تم توليدها
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  } catch (e) {
    print("خطأ في تهيئة فايربيس: $e");
  }

  // 4. تهيئة Workmanager لجدولة المزامنة في الخلفية
  Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  Workmanager().registerPeriodicTask(
    "offline_sync_task",
    "syncTickets",
    frequency: const Duration(minutes: 15), // الحد الأدنى المسموح به في أندرويد هو 15 دقيقة
    constraints: Constraints(
      networkType: NetworkType.connected, // يشترط وجود اتصال بالإنترنت لتعمل المهمة
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TicketProvider()),
        ChangeNotifierProvider(create: (_) => InventoryProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: const MobileMaintenanceApp(),
    ),
  );
}

class MobileMaintenanceApp extends StatelessWidget {
  const MobileMaintenanceApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Albaik Maintenance',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainNavigationScreen(),
    );
  }
}