import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import '../providers/settings_provider.dart';
import '../providers/inventory_provider.dart';
import '../services/printer_service.dart';
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
  late TextEditingController _cleanupDaysCtrl;
  
  bool _isExporting = false;
  bool _isSyncingPrices = false;
  bool _autoCleanupEnabled = false;

  // متغيرات البلوتوث الجديدة
  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _selectedDevice;
  bool _isFetchingDevices = false;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<SettingsProvider>(context, listen: false);
    _tokenCtrl = TextEditingController(text: provider.telegramBotToken);
    _chatIdCtrl = TextEditingController(text: provider.telegramChatId);
    
    _autoCleanupEnabled = provider.autoCleanupEnabled;
    _cleanupDaysCtrl = TextEditingController(text: provider.autoCleanupDays.toString());

    _initBluetooth();
  }

  @override
  void dispose() {
    _tokenCtrl.dispose();
    _chatIdCtrl.dispose();
    _cleanupDaysCtrl.dispose();
    super.dispose();
  }

  void _unfocusAll() => FocusManager.instance.primaryFocus?.unfocus();

  // دالة جلب الأجهزة المقترنة بالبلوتوث
  Future<void> _initBluetooth() async {
    setState(() => _isFetchingDevices = true);
    try {
      List<BluetoothDevice> devices = await PrinterService.bluetooth.getBondedDevices();
      if (!mounted) return;
      
      setState(() {
        _devices = devices;
        final savedMac = Provider.of<SettingsProvider>(context, listen: false).printerMac;
        
        // محاولة تحديد الطابعة المحفوظة مسبقاً إن وجدت
        if (savedMac.isNotEmpty) {
          try {
            _selectedDevice = _devices.firstWhere((d) => d.address == savedMac);
          } catch (e) {
            _selectedDevice = null;
          }
        }
      });
    } catch (e) {
      _showMessage('خطأ في جلب أجهزة البلوتوث المقترنة', isError: true);
    }
    if (mounted) {
      setState(() => _isFetchingDevices = false);
    }
  }

  Future<void> _checkPrinterConnection(String macAddress) async {
    try {
      final connected = await PrinterService.bluetooth.isConnected;
      if (connected == true) {
        _showMessage('الطابعة متصلة حالياً');
        return;
      }

      if (macAddress.isEmpty) {
        _showMessage('يرجى اختيار الطابعة من القائمة أولاً', isError: true);
        return;
      }

      await PrinterService.bluetooth.connect(BluetoothDevice('Printer', macAddress));
      final nowConnected = await PrinterService.bluetooth.isConnected;
      if (nowConnected == true) {
        _showMessage('تم الاتصال بالطابعة بنجاح');
      } else {
        _showMessage('فشل اتصال الطابعة. تأكد من تشغيلها وإقرانها من الجهاز', isError: true);
      }
    } catch (e) {
      _showMessage('خطأ في فحص الطابعة: $e', isError: true);
    }
  }

  Future<void> _printTestPage(String macAddress) async {
    if (macAddress.isEmpty) {
      _showMessage('يرجى اختيار الطابعة من القائمة أولاً', isError: true);
      return;
    }

    try {
      await PrinterService.testPrinter(macAddress);
      _showMessage('تم إرسال الطباعة التجريبية بنجاح');
    } catch (e) {
      _showMessage('فشل في طباعة الصفحة التجريبية: $e', isError: true);
    }
  }

  void _showMessage(String text, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: isError ? AppTheme.albaikRichRed : Colors.green.shade700,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SettingsProvider>(context);

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
                  
                  final inventoryProvider = Provider.of<InventoryProvider>(context, listen: false);
                  final resultMessage = await inventoryProvider.syncPricesFromCloud();
                  
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

              // إعدادات الطابعة (تم التعديل لتصبح قائمة منسدلة)
              const Text('إعدادات الطابعة (Bluetooth)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.albaikDeepNavy)),
              const SizedBox(height: 8),
              const Text('تأكد من اقتران الطابعة بالجوال من إعدادات النظام لتظهر في القائمة.', style: TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 12),
              
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<BluetoothDevice>(
                      decoration: const InputDecoration(
                        labelText: 'اختر الطابعة المقترنة',
                        prefixIcon: Icon(Icons.bluetooth),
                      ),
                      value: _selectedDevice,
                      items: _devices.map((device) {
                        return DropdownMenuItem<BluetoothDevice>(
                          value: device,
                          child: Text(
                            device.name ?? 'جهاز غير معروف',
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (BluetoothDevice? device) {
                        if (device != null) {
                          setState(() {
                            _selectedDevice = device;
                            provider.printerMac = device.address ?? '';
                          });
                        }
                      },
                      hint: _isFetchingDevices 
                          ? const Text('جاري البحث...') 
                          : const Text('اضغط لاختيار الطابعة'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.albaikDeepNavy.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.refresh, color: AppTheme.albaikDeepNavy),
                      onPressed: _initBluetooth,
                      tooltip: 'تحديث القائمة',
                    ),
                  ),
                ],
              ),
              
              if (_selectedDevice != null) ...[
                const SizedBox(height: 8),
                Text(
                  'MAC Address: ${_selectedDevice!.address}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  textAlign: TextAlign.left,
                ),
              ],
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.wifi_protected_setup),
                      label: const Text('فحص اتصال الطابعة'),
                      onPressed: () => _checkPrinterConnection(provider.printerMac),
                      style: ElevatedButton.styleFrom(backgroundColor: AppTheme.albaikDeepNavy),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.print),
                      label: const Text('طباعة تجريبية'),
                      onPressed: () => _printTestPage(provider.printerMac),
                      style: OutlinedButton.styleFrom(side: const BorderSide(color: AppTheme.albaikDeepNavy)),
                    ),
                  ),
                ],
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
                activeThumbColor: AppTheme.albaikRichRed,
                activeTrackColor: AppTheme.albaikRichRed.withValues(alpha: 0.5),
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
              
              // زر حفظ الإعدادات
              ElevatedButton(
                onPressed: () async {
                  _unfocusAll();
                  provider.saveSettings(_tokenCtrl.text.trim(), _chatIdCtrl.text.trim(), provider.printerMac);
                  
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