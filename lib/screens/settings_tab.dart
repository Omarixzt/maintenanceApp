import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/custom_app_bar.dart';
import '../theme/app_theme.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({Key? key}) : super(key: key);

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  late TextEditingController _tokenCtrl;
  late TextEditingController _chatIdCtrl;
  late TextEditingController _macCtrl;
  late TextEditingController _cleanupDaysCtrl;
  bool _isExporting = false;
  bool _isSyncingPrices = false;
  bool _autoCleanupEnabled = false;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<AppProvider>(context, listen: false);
    _tokenCtrl = TextEditingController(text: provider.telegramBotToken);
    _chatIdCtrl = TextEditingController(text: provider.telegramChatId);
    _macCtrl = TextEditingController(text: provider.printerMac);
    
    _autoCleanupEnabled = provider.autoCleanupEnabled;
    _cleanupDaysCtrl = TextEditingController(text: provider.autoCleanupDays.toString());
  }

  @override
  void dispose() {
    _tokenCtrl.dispose();
    _chatIdCtrl.dispose();
    _macCtrl.dispose();
    _cleanupDaysCtrl.dispose();
    super.dispose();
  }

  void _unfocusAll() => FocusManager.instance.primaryFocus?.unfocus();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'الإعدادات والتقارير'),
      body: GestureDetector(
        onTap: _unfocusAll,
        behavior: HitTestBehavior.opaque,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // قسم تحديث الأسعار السحابية
              const Text('تحديث بيانات الموردين', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.albaikDeepNavy)),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                icon: _isSyncingPrices 
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
                    : const Icon(Icons.cloud_download),
                label: const Text('جلب أحدث أسعار الشاشات من السحابة'),
                onPressed: _isSyncingPrices ? null : () async {
                  _unfocusAll();
                  setState(() => _isSyncingPrices = true);
                  
                  final resultMessage = await provider.syncPricesFromCloud();
                  
                  setState(() => _isSyncingPrices = false);
                  
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(resultMessage),
                        duration: const Duration(seconds: 5),
                      )
                    );
                  }
                },
              ),
              const SizedBox(height: 32),
              Divider(color: Colors.grey.shade300, thickness: 1),
              const SizedBox(height: 32),

              // إعدادات الطابعة
              const Text('إعدادات الطابعة (Bluetooth)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.albaikDeepNavy)),
              const SizedBox(height: 12),
              TextFormField(
                controller: _macCtrl,
                decoration: const InputDecoration(labelText: 'MAC Address للطابعة', prefixIcon: Icon(Icons.print_outlined)),
              ),
              const SizedBox(height: 32),
              
              // إعدادات Telegram
              const Text('إعدادات تقارير Telegram', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.albaikDeepNavy)),
              const SizedBox(height: 12),
              TextFormField(
                controller: _tokenCtrl,
                decoration: const InputDecoration(labelText: 'Bot Token', prefixIcon: Icon(Icons.security_outlined)),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _chatIdCtrl,
                decoration: const InputDecoration(labelText: 'Chat ID', prefixIcon: Icon(Icons.chat_bubble_outline)),
              ),
              
              const SizedBox(height: 32),
              Divider(color: Colors.grey.shade300, thickness: 1),
              const SizedBox(height: 32),

              // إدارة مساحة التخزين
              const Text('إدارة مساحة التخزين', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.albaikDeepNavy)),
              const SizedBox(height: 8),
              const Text('تقوم هذه الميزة بحذف صور الأجهزة المؤرشفة لتوفير المساحة مع الاحتفاظ بسجل التكلفة والأرباح والعطل.', style: TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 16),
              
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('التنظيف التلقائي للصور', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(_autoCleanupEnabled ? 'مفعل (يعمل عند فتح التطبيق)' : 'معطل'),
                activeColor: AppTheme.albaikRichRed,
                value: _autoCleanupEnabled,
                onChanged: (val) {
                  _unfocusAll();
                  setState(() {
                    _autoCleanupEnabled = val;
                  });
                },
              ),
              
              if (_autoCleanupEnabled) ...[
                const SizedBox(height: 12),
                TextFormField(
                  controller: _cleanupDaysCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'حذف الصور للأجهزة الأقدم من (بالأيام)', 
                    prefixIcon: Icon(Icons.timer_outlined)
                  ),
                ),
              ],

              const SizedBox(height: 16),
              OutlinedButton.icon(
                icon: const Icon(Icons.cleaning_services),
                label: const Text('تنظيف الصور القديمة الآن'),
                style: OutlinedButton.styleFrom(foregroundColor: AppTheme.albaikRichRed, side: const BorderSide(color: AppTheme.albaikRichRed)),
                onPressed: () async {
                  _unfocusAll();
                  int days = int.tryParse(_cleanupDaysCtrl.text) ?? 90;
                  
                  // رسالة التأكيد
                  bool? confirm = await showDialog<bool>(
                    context: context,
                    builder: (BuildContext ctx) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        title: const Row(
                          children: [
                            Icon(Icons.warning_amber_rounded, color: AppTheme.albaikRichRed),
                            SizedBox(width: 8),
                            Text('تأكيد الحذف', style: TextStyle(color: AppTheme.albaikRichRed, fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        content: Text('هل أنت متأكد أنك تريد حذف صور الأجهزة المؤرشفة الأقدم من $days يوم؟\n\nتنبيه: لا يمكن استرجاع الصور بعد حذفها.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: const Text('إلغاء', style: TextStyle(color: AppTheme.albaikDeepNavy)),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.albaikRichRed),
                            onPressed: () => Navigator.pop(ctx, true),
                            child: const Text('نعم، احذف الصور'),
                          ),
                        ],
                      );
                    },
                  );

                  if (confirm != true) return;

                  await provider.updateAutoCleanupSettings(_autoCleanupEnabled, days);
                  
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('جاري تنظيف الصور...')));
                  
                  int deleted = await provider.cleanupOldImages(force: true);
                  
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('اكتمل التنظيف. تم مسح $deleted صورة'),
                      backgroundColor: Colors.green.shade700,
                    ));
                  }
                },
              ),

              const SizedBox(height: 32),
              
              // زر حفظ الإعدادات (تمت إعادته هنا)
              ElevatedButton(
                onPressed: () async {
                  _unfocusAll();
                  provider.saveSettings(_tokenCtrl.text.trim(), _chatIdCtrl.text.trim(), _macCtrl.text.trim());
                  
                  int days = int.tryParse(_cleanupDaysCtrl.text) ?? 90;
                  await provider.updateAutoCleanupSettings(_autoCleanupEnabled, days);

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم حفظ الإعدادات بنجاح')));
                  }
                },
                child: const Text('حفظ جميع الإعدادات'),
              ),
              
              const SizedBox(height: 32),
              Divider(color: Colors.grey.shade300, thickness: 1),
              const SizedBox(height: 32),
              
              // زر الإرسال إلى تليجرام
              ElevatedButton.icon(
                icon: _isExporting 
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
                    : const Icon(Icons.send),
                label: const Text('إرسال الأرشيف الشهري إلى Telegram'),
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.albaikRichRed),
                onPressed: _isExporting ? null : () async {
                  _unfocusAll();
                  setState(() => _isExporting = true);
                  final success = await provider.sendMonthlyArchiveToTelegram();
                  setState(() => _isExporting = false);
                  
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(success ? 'تم الإرسال بنجاح' : 'فشل الإرسال، تأكد من الإعدادات والإنترنت'),
                        backgroundColor: success ? Colors.green.shade700 : AppTheme.albaikRichRed,
                      )
                    );
                  }
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}