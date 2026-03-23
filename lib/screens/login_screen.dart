import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../admin_dashboard.dart'; // استدعاء شاشة الإدارة الموجودة بجانب main.dart

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _codeCtrl = TextEditingController();
  bool _isLoading = false;
  
  // عداد الضغطات المخفية
  int _secretTapCount = 0;

  void _login() async {
    final code = _codeCtrl.text.trim();
    if (code.isEmpty) return;

    setState(() => _isLoading = true);
    FocusManager.instance.primaryFocus?.unfocus();

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final result = await authProvider.verifySubscription(code);

    if (mounted) {
      setState(() => _isLoading = false);
      if (!result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message']), backgroundColor: AppTheme.albaikRichRed),
        );
      }
    }
  }

  // نافذة إدخال الرمز السري الخاصة بالمدير
  void _showAdminPasscodeDialog() {
    final passcodeCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.admin_panel_settings, color: AppTheme.albaikDeepNavy),
            SizedBox(width: 8),
            Text('صلاحيات الإدارة', style: TextStyle(color: AppTheme.albaikDeepNavy, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: TextField(
          controller: passcodeCtrl,
          keyboardType: TextInputType.number,
          obscureText: true, // إخفاء الرمز أثناء الكتابة
          decoration: InputDecoration(
            labelText: 'أدخل رمز المرور',
            prefixIcon: const Icon(Icons.lock_outline),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _secretTapCount = 0; // تصفير العداد عند الإلغاء
            },
            child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.albaikDeepNavy),
            onPressed: () {
              if (passcodeCtrl.text == '202609') {
                Navigator.pop(ctx); // إغلاق النافذة
                _secretTapCount = 0; // تصفير العداد
                
                // الانتقال إلى لوحة تحكم الإدارة
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminDashboard()),
                );
              } else {
                Navigator.pop(ctx);
                _secretTapCount = 0; // تصفير العداد
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('رمز المرور غير صحيح!'), backgroundColor: AppTheme.albaikRichRed),
                );
              }
            },
            child: const Text('دخول'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.albaikDeepNavy,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppTheme.albaikPureWhite,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20)],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // الشعار مع زر الضغطات المخفية (GestureDetector)
                GestureDetector(
                  onTap: () {
                    _secretTapCount++;
                    if (_secretTapCount >= 15) {
                      _showAdminPasscodeDialog();
                    }
                  },
                  child: const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.transparent,
                    backgroundImage: AssetImage('lib/assets/logo.png'),
                  ),
                ),
                const SizedBox(height: 24),
                const Text('تسجيل الدخول', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.albaikDeepNavy)),
                const SizedBox(height: 8),
                const Text('أدخل كود التفعيل الخاص بمحلك', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 32),
                TextField(
                  controller: _codeCtrl,
                  decoration: InputDecoration(
                    labelText: 'كود التفعيل',
                    prefixIcon: const Icon(Icons.vpn_key_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.albaikRichRed),
                    child: _isLoading 
                        ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('دخول', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}