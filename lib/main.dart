import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workmanager/workmanager.dart'; 
import 'package:isar/isar.dart'; 
import 'firebase_options.dart';
import 'services/isar_service.dart';
import 'providers/ticket_provider.dart';
import 'providers/inventory_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/auth_provider.dart'; // <-- استدعاء مزود المصادقة الجديد
import 'screens/main_navigation_screen.dart';
import 'screens/login_screen.dart'; // <-- استدعاء شاشة تسجيل الدخول
import 'theme/app_theme.dart';
import 'models/app_models.dart'; 

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
        // التأكد من وجود كود المحل والـ ID قبل الرفع
        if (ticket.firebaseId != null && ticket.firebaseId!.isNotEmpty && ticket.shopId.isNotEmpty) {
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
        ChangeNotifierProvider(create: (_) => AuthProvider()), // <-- تسجيل مزود المصادقة أولاً ليعمل قبل الجميع
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
      title: 'نظام الصيانة',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      locale: const Locale('ar', 'JO'), // لضمان دعم الواجهة العربية
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      // توجيه ذكي بناءً على حالة كود التفعيل
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          // أثناء التحقق من الذاكرة المحلية أو السيرفر
          if (auth.isChecking) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          // التعديل هنا: نطرده إذا كان المتغير null أو نص فارغ
          if (auth.currentShopId == null || auth.currentShopId!.trim().isEmpty) {
            return const LoginScreen();
          }
          // إذا كان يملك كوداً (سواء ساري أو منتهي)، يدخل للتطبيق
          // (سيتم التعامل مع وضع القراءة فقط داخل MainNavigationScreen)
          return const MainNavigationScreen();
        },
      ),
    );
  }
}