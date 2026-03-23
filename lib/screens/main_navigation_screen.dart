import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/isar_service.dart';
import 'intake_tab.dart';
import 'workspace_tab.dart';
import 'inventory_tab.dart';
import 'archive_tab.dart';
import 'settings_tab.dart';
import '../theme/app_theme.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    IntakeTab(),
    WorkspaceTab(),
    InventoryTab(),
    ArchiveTab(),
    SettingsTab(),
  ];

  @override
  void initState() {
    super.initState();
    // تأجيل الفحص حتى يكتمل بناء الواجهة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForMonthlyReportAlert();
    });
  }

  Future<void> _checkForMonthlyReportAlert() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.isReadOnly) return; // لا نظهر التنبيه إذا كان الحساب منتهياً

    DateTime now = DateTime.now();
    String currentMonthKey = '${now.year}_${now.month}';
    
    // جلب آخر شهر تم التنبيه عنه
    String? lastNotifiedMonth = await IsarService.getSetting('last_report_notification');

    // إذا لم يتم التنبيه في هذا الشهر من قبل
    if (lastNotifiedMonth != currentMonthKey) {
      // تحديد الشهر الماضي لحساب التقرير
      int lastMonth = now.month == 1 ? 12 : now.month - 1;
      int yearOfLastMonth = now.month == 1 ? now.year - 1 : now.year;

      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.insert_chart, color: AppTheme.albaikDeepNavy, size: 30),
              SizedBox(width: 10),
              Text('جاهزية التقرير الشهري', style: TextStyle(color: AppTheme.albaikDeepNavy, fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          content: Text('نحن الآن في بداية شهر جديد.\nالتقرير المالي والتشغيلي لشهر ($lastMonth) أصبح جاهزاً للإصدار الآن.\n\nهل ترغب في الذهاب للإعدادات لتصديره ومراجعته؟'),
          actions: [
            TextButton(
              onPressed: () async {
                await IsarService.saveSetting('last_report_notification', currentMonthKey);
                Navigator.pop(ctx);
              },
              child: const Text('لاحقاً', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.albaikDeepNavy),
              onPressed: () async {
                await IsarService.saveSetting('last_report_notification', currentMonthKey);
                Navigator.pop(ctx);
                setState(() {
                  _currentIndex = 4; // الانتقال مباشرة لتبويب الإعدادات
                });
              },
              child: const Text('الذهاب للتصدير'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isReadOnly = authProvider.isReadOnly;

    return Scaffold(
      body: Column(
        children: [
          if (isReadOnly)
            Container(
              color: AppTheme.albaikRichRed,
              padding: const EdgeInsets.only(top: 40, bottom: 8, left: 16, right: 16),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Colors.white),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'الاشتراك منتهي! وضع القراءة فقط (السجل)',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                  TextButton(
                    onPressed: () => authProvider.logout(),
                    child: const Text('خروج', style: TextStyle(color: Colors.white, decoration: TextDecoration.underline)),
                  )
                ],
              ),
            ),
          
          Expanded(
            child: isReadOnly 
                ? const SafeArea(child: ArchiveTab())
                : SafeArea(
                    child: IndexedStack(
                      index: _currentIndex,
                      children: _screens,
                    ),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: isReadOnly 
          ? null 
          : Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5)),
                ],
              ),
              child: BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: (index) => setState(() => _currentIndex = index),
                type: BottomNavigationBarType.fixed,
                backgroundColor: AppTheme.albaikPureWhite,
                selectedItemColor: AppTheme.albaikRichRed,
                unselectedItemColor: AppTheme.albaikDeepNavy.withOpacity(0.4),
                selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
                elevation: 0,
                items: const [
                  BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), activeIcon: Icon(Icons.add_circle), label: 'استلام'),
                  BottomNavigationBarItem(icon: Icon(Icons.build_outlined), activeIcon: Icon(Icons.build), label: 'الورشة'),
                  BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), activeIcon: Icon(Icons.inventory_2), label: 'المخزون'),
                  BottomNavigationBarItem(icon: Icon(Icons.history_outlined), activeIcon: Icon(Icons.history), label: 'السجل'),
                  BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), activeIcon: Icon(Icons.settings), label: 'الإعدادات'),
                ],
              ),
            ),
    );
  }
}