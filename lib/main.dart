import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart'; // استيراد ملف إعدادات فايربيس الجديد
import 'services/isar_service.dart';
import 'providers/app_provider.dart';
import 'screens/main_navigation_screen.dart'; // تأكد من المسار الصحيح حسب مجلداتك
import 'theme/app_theme.dart'; // <-- تم إضافة استيراد ملف الثيم المركزي هنا

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. تهيئة قاعدة البيانات المحلية Isar
  await IsarService.init();
  
  // 2. تهيئة فايربيس بشكل صحيح باستخدام المفاتيح التي تم توليدها
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

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
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
      title: 'FixIT Pro',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme, // <-- تم ربط التطبيق بالثيم المركزي هنا بدلاً من الكود الطويل
      home: const MainNavigationScreen(),
    );
  }
}