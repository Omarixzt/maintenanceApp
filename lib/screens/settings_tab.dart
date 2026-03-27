import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/settings_provider.dart';
import '../providers/inventory_provider.dart';
import '../services/printer_service.dart';
import '../services/isar_service.dart';
import '../theme/custom_app_bar.dart';
import '../theme/app_theme.dart';

class ReceiptElement {
  String id;
  String label;
  bool isEnabledCustomer;
  bool isEnabledDevice;
  bool isCustom;
  String? customText;

  ReceiptElement({
    required this.id,
    required this.label,
    this.isEnabledCustomer = true,
    this.isEnabledDevice = true,
    this.isCustom = false,
    this.customText,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'label': label,
      'isEnabledCustomer': isEnabledCustomer,
      'isEnabledDevice': isEnabledDevice,
      'isCustom': isCustom,
      'customText': customText,
    };
  }

  factory ReceiptElement.fromMap(Map<String, dynamic> map) {
    return ReceiptElement(
      id: map['id'],
      label: map['label'],
      isEnabledCustomer: map['isEnabledCustomer'] ?? map['isEnabled'] ?? true,
      isEnabledDevice: map['isEnabledDevice'] ?? map['isEnabled'] ?? true,
      isCustom: map['isCustom'] ?? false,
      customText: map['customText'],
    );
  }
}

class SettingsTab extends StatefulWidget {
  const SettingsTab({Key? key}) : super(key: key);

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  late TextEditingController _tokenCtrl;
  late TextEditingController _chatIdCtrl;
  late TextEditingController _cleanupDaysCtrl;
  
  late TextEditingController _storeNameCtrl;
  late TextEditingController _storeAddressCtrl;
  late TextEditingController _storePhoneCtrl;
  String? _customLogoPath;
  
  bool _isExporting = false;
  bool _isSyncingPrices = false;
  bool _autoCleanupEnabled = false;

  // متغيرات التقرير الشهري
  int _selectedReportMonth = DateTime.now().month;
  int _selectedReportYear = DateTime.now().year;

  List<BluetoothInfo> _devices = [];
  BluetoothInfo? _selectedDevice;
  bool _isFetchingDevices = false;

  List<ReceiptElement> _receiptLayout = [];
  bool _isLoadingLayout = true;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<SettingsProvider>(context, listen: false);
    _tokenCtrl = TextEditingController(text: provider.telegramBotToken);
    _chatIdCtrl = TextEditingController(text: provider.telegramChatId);
    
    _autoCleanupEnabled = provider.autoCleanupEnabled;
    _cleanupDaysCtrl = TextEditingController(text: provider.autoCleanupDays.toString());

    _storeNameCtrl = TextEditingController();
    _storeAddressCtrl = TextEditingController();
    _storePhoneCtrl = TextEditingController();

    _initBluetooth();
    _loadSettingsData();
  }

  @override
  void dispose() {
    _tokenCtrl.dispose();
    _chatIdCtrl.dispose();
    _cleanupDaysCtrl.dispose();
    _storeNameCtrl.dispose();
    _storeAddressCtrl.dispose();
    _storePhoneCtrl.dispose();
    super.dispose();
  }

  void _unfocusAll() => FocusManager.instance.primaryFocus?.unfocus();

  Future<void> _loadSettingsData() async {
    _storeNameCtrl.text = await IsarService.getSetting('store_name') ?? 'صيانة';
    _storeAddressCtrl.text = await IsarService.getSetting('store_address') ?? 'إربد - الأردن';
    _storePhoneCtrl.text = await IsarService.getSetting('store_phone') ?? '0778710836';
    _customLogoPath = await IsarService.getSetting('store_logo_path');

    String? savedJson = await IsarService.getSetting('receipt_layout');
    if (savedJson != null && savedJson.isNotEmpty) {
      List<dynamic> decoded = jsonDecode(savedJson);
      _receiptLayout = decoded.map((item) => ReceiptElement.fromMap(item)).toList();
    } else {
      _receiptLayout = [
        ReceiptElement(id: 'logo', label: 'الشعار (Logo)', isEnabledDevice: false),
        ReceiptElement(id: 'header', label: 'ترويسة المحل'),
        ReceiptElement(id: 'ticket_info', label: 'رقم الوصل والتاريخ'),
        ReceiptElement(id: 'delivery', label: 'تاريخ التسليم المتوقع', isEnabledDevice: false),
        ReceiptElement(id: 'customer', label: 'معلومات العميل'),
        ReceiptElement(id: 'device', label: 'معلومات الجهاز والعطل'),
        ReceiptElement(id: 'cost', label: 'التكلفة المتوقعة', isEnabledDevice: false),
        ReceiptElement(id: 'footer', label: 'التذييل (أرقام التواصل)', isEnabledDevice: false),
      ];
    }
    setState(() => _isLoadingLayout = false);
  }

  Future<void> _pickLogo() async {
    _unfocusAll();
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    
    if (image != null) {
      setState(() {
        _customLogoPath = image.path;
      });
    }
  }

  Future<void> _saveAllLocalSettings() async {
    List<Map<String, dynamic>> layoutData = _receiptLayout.map((e) => e.toMap()).toList();
    await IsarService.saveSetting('receipt_layout', jsonEncode(layoutData));
    
    await IsarService.saveSetting('store_name', _storeNameCtrl.text.trim());
    await IsarService.saveSetting('store_address', _storeAddressCtrl.text.trim());
    await IsarService.saveSetting('store_phone', _storePhoneCtrl.text.trim());
    
    if (_customLogoPath != null) {
      await IsarService.saveSetting('store_logo_path', _customLogoPath!);
    } else {
      await IsarService.saveSetting('store_logo_path', ''); 
    }
  }

  Future<void> _initBluetooth() async {
    setState(() => _isFetchingDevices = true);
    try {
      List<BluetoothInfo> devices = await PrintBluetoothThermal.pairedBluetooths;
      if (!mounted) return;
      
      setState(() {
        _devices = devices;
        final savedMac = Provider.of<SettingsProvider>(context, listen: false).printerMac;
        if (savedMac.isNotEmpty) {
          try {
            _selectedDevice = _devices.firstWhere((d) => d.macAdress == savedMac);
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
    if (macAddress.isEmpty) {
      _showMessage('يرجى اختيار الطابعة من القائمة أولاً', isError: true);
      return;
    }
    try {
      final connected = await PrintBluetoothThermal.connectionStatus;
      if (connected == true) {
        _showMessage('الطابعة متصلة حالياً');
        return;
      }
      _showMessage('جاري الاتصال بالطابعة...');
      final nowConnected = await PrintBluetoothThermal.connect(macPrinterAddress: macAddress);
      if (nowConnected == true) {
        _showMessage('تم الاتصال بالطابعة بنجاح');
      } else {
        _showMessage('فشل اتصال الطابعة. تأكد من تشغيلها', isError: true);
      }
    } catch (e) {
      _showMessage('خطأ في فحص الطابعة: $e', isError: true);
    }
  }

  Future<void> _printTestPage(String macAddress) async {
    if (macAddress.isEmpty) {
      _showMessage('يرجى اختيار الطابعة أولاً', isError: true);
      return;
    }
    try {
      await PrinterService.testPrinter(macAddress);
      _showMessage('تم إرسال الطباعة التجريبية بنجاح');
    } catch (e) {
      _showMessage('فشل في طباعة الصفحة التجريبية: $e', isError: true);
    }
  }

  void _addCustomTextElement() {
    TextEditingController textCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('إضافة نص مخصص للفاتورة'),
        content: TextField(
          controller: textCtrl,
          decoration: const InputDecoration(hintText: 'مثال: البضاعة المباعة لا ترد...'),
          maxLines: 2,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              if (textCtrl.text.trim().isNotEmpty) {
                setState(() {
                  _receiptLayout.add(ReceiptElement(
                    id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
                    label: 'نص مخصص',
                    isCustom: true,
                    customText: textCtrl.text.trim(),
                  ));
                });
              }
              Navigator.pop(ctx);
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
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
              const Text('تحديث بيانات الموردين', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.albaikDeepNavy)),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                icon: _isSyncingPrices 
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
                    : const Icon(Icons.cloud_download),
                label: const Text('جلب أحدث أسعار الشاشات من السحابة'),
                
                // التعديل هنا: الزر يعمل فقط إذا كانت الصلاحية (allowPriceSync) مفعلة وغير قيد التحميل
                onPressed: (provider.allowPriceSync && !_isSyncingPrices) ? () async {
                  _unfocusAll();
                  setState(() => _isSyncingPrices = true);
                  
                  final inventoryProvider = Provider.of<InventoryProvider>(context, listen: false);
                  
                  // تنفيذ عملية الجلب
                  final resultMessage = await inventoryProvider.syncPricesFromCloud(); 
                  
                  // إطفاء الصلاحية فوراً بعد الاستخدام ليصبح الزر رمادياً مرة أخرى
                  await provider.consumePriceSyncPermission();
                  
                  if (mounted) {
                    setState(() => _isSyncingPrices = false);
                    _showMessage(resultMessage);
                  }
                } : null, // تمرير null يجعل الزر رمادياً وغير قابل للضغط
              ),
              const SizedBox(height: 32),
              Divider(color: Colors.grey.shade300, thickness: 1),
              const SizedBox(height: 32),

              const Text('بيانات المحل للطباعة (الفاتورة)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.albaikDeepNavy)),
              const SizedBox(height: 8),
              const Text('هذه البيانات ستظهر في ترويسة وتذييل الفاتورة المطبوعة.', style: TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 16),
              TextFormField(
                controller: _storeNameCtrl,
                decoration: const InputDecoration(labelText: 'اسم المحل', prefixIcon: Icon(Icons.store)),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _storeAddressCtrl,
                decoration: const InputDecoration(labelText: 'العنوان', prefixIcon: Icon(Icons.location_on)),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _storePhoneCtrl,
                decoration: const InputDecoration(labelText: 'رقم الهاتف', prefixIcon: Icon(Icons.phone)),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.image),
                      label: const Text('تغيير شعار الفاتورة'),
                      onPressed: _pickLogo,
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (_customLogoPath != null && _customLogoPath!.isNotEmpty)
                    Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: FileImage(File(_customLogoPath!)),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => setState(() => _customLogoPath = null),
                          child: Container(
                            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                            child: const Icon(Icons.cancel, color: Colors.red, size: 20),
                          ),
                        )
                      ],
                    )
                  else
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(child: Text('الافتراضي', style: TextStyle(fontSize: 10))),
                    ),
                ],
              ),
              const SizedBox(height: 32),
              Divider(color: Colors.grey.shade300, thickness: 1),
              const SizedBox(height: 32),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('تخصيص شكل الفاتورة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.albaikDeepNavy)),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, color: AppTheme.albaikRichRed),
                    onPressed: _addCustomTextElement,
                    tooltip: 'إضافة نص مخصص',
                  )
                ],
              ),
              const Text('قم بسحب العناصر لإعادة ترتيبها، وحدد خيارات الطباعة لكل عنصر.', style: TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 12),
              
              if (_isLoadingLayout)
                const Center(child: CircularProgressIndicator())
              else
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ReorderableListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _receiptLayout.length,
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        if (newIndex > oldIndex) newIndex -= 1;
                        final item = _receiptLayout.removeAt(oldIndex);
                        _receiptLayout.insert(newIndex, item);
                      });
                    },
                    itemBuilder: (context, index) {
                      final item = _receiptLayout[index];
                      return Container(
                        key: ValueKey(item.id),
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                          color: Colors.white,
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.only(left: 16, right: 8),
                          leading: const Icon(Icons.drag_indicator, color: Colors.grey),
                          title: Text(item.isCustom ? '${item.label}: ${item.customText}' : item.label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (item.isCustom)
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                                  onPressed: () {
                                    setState(() => _receiptLayout.removeAt(index));
                                  },
                                ),
                              const SizedBox(width: 8),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('للزبون', style: TextStyle(fontSize: 10, color: AppTheme.albaikDeepNavy)),
                                  SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: Checkbox(
                                      activeColor: AppTheme.albaikRichRed,
                                      value: item.isEnabledCustomer,
                                      onChanged: (val) {
                                        setState(() => item.isEnabledCustomer = val ?? true);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 12),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('للمحل', style: TextStyle(fontSize: 10, color: AppTheme.albaikDeepNavy)),
                                  SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: Checkbox(
                                      activeColor: AppTheme.albaikRichRed,
                                      value: item.isEnabledDevice,
                                      onChanged: (val) {
                                        setState(() => item.isEnabledDevice = val ?? true);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 32),
              Divider(color: Colors.grey.shade300, thickness: 1),
              const SizedBox(height: 32),

              const Text('إعدادات الطابعة (Bluetooth)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.albaikDeepNavy)),
              const SizedBox(height: 8),
              const Text('تأكد من اقتران الطابعة بالجوال من إعدادات النظام لتظهر في القائمة.', style: TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 12),
              
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<BluetoothInfo>(
                      decoration: const InputDecoration(
                        labelText: 'اختر الطابعة المقترنة',
                        prefixIcon: Icon(Icons.bluetooth),
                      ),
                      value: _selectedDevice,
                      items: _devices.map((device) {
                        return DropdownMenuItem<BluetoothInfo>(
                          value: device,
                          child: Text(
                            device.name.isNotEmpty ? device.name : 'جهاز غير معروف',
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (BluetoothInfo? device) {
                        if (device != null) {
                          setState(() {
                            _selectedDevice = device;
                            provider.printerMac = device.macAdress;
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
                  'MAC Address: ${_selectedDevice!.macAdress}',
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
              Divider(color: Colors.grey.shade300, thickness: 1),
              const SizedBox(height: 32),
              
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

              const Text('إدارة مساحة التخزين', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.albaikDeepNavy)),
              const SizedBox(height: 8),
              const Text('تقوم هذه الميزة بحذف صور الأجهزة المؤرشفة لتوفير المساحة.', style: TextStyle(color: Colors.grey, fontSize: 12)),
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
                  setState(() => _autoCleanupEnabled = val);
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
                    builder: (ctx) => AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      title: const Row(
                        children: [
                          Icon(Icons.warning_amber_rounded, color: AppTheme.albaikRichRed),
                          SizedBox(width: 8),
                          Text('تأكيد الحذف', style: TextStyle(color: AppTheme.albaikRichRed, fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      content: Text('هل أنت متأكد أنك تريد حذف صور الأجهزة المؤرشفة الأقدم من $days يوم؟\nلا يمكن استرجاع الصور.'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('إلغاء')),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.albaikRichRed),
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text('نعم، احذف الصور'),
                        ),
                      ],
                    ),
                  );

                  if (confirm != true) return;

                  await provider.updateAutoCleanupSettings(_autoCleanupEnabled, days);
                  if (!context.mounted) return;
                  _showMessage('جاري تنظيف الصور...');
                  int deleted = await provider.cleanupOldImages(force: true);
                  _showMessage('اكتمل التنظيف. تم مسح $deleted صورة');
                },
              ),

              const SizedBox(height: 32),
              
              ElevatedButton(
                onPressed: () async {
                  _unfocusAll();
                  provider.saveSettings(_tokenCtrl.text.trim(), _chatIdCtrl.text.trim(), provider.printerMac);
                  int days = int.tryParse(_cleanupDaysCtrl.text) ?? 90;
                  await provider.updateAutoCleanupSettings(_autoCleanupEnabled, days);
                  await _saveAllLocalSettings(); 
                  _showMessage('تم حفظ الإعدادات بنجاح');
                },
                child: const Text('حفظ جميع الإعدادات'),
              ),
              
              const SizedBox(height: 32),
              Divider(color: Colors.grey.shade300, thickness: 1),
              const SizedBox(height: 32),
              
              const Text('إصدار التقرير الشهري', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.albaikDeepNavy)),
              const SizedBox(height: 8),
              const Text('توليد تقرير PDF احترافي ومنسق يحتوي على الحسابات وإجمالي الأجهزة.', style: TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: _selectedReportMonth,
                      decoration: const InputDecoration(labelText: 'الشهر', border: OutlineInputBorder()),
                      items: List.generate(12, (index) => DropdownMenuItem(value: index + 1, child: Text('شهر ${index + 1}'))),
                      onChanged: (val) => setState(() => _selectedReportMonth = val!),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: _selectedReportYear,
                      decoration: const InputDecoration(labelText: 'السنة', border: OutlineInputBorder()),
                      items: List.generate(5, (index) => DropdownMenuItem(value: DateTime.now().year - index, child: Text('${DateTime.now().year - index}'))),
                      onChanged: (val) => setState(() => _selectedReportYear = val!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.download),
                      label: const Text('حفظ / مشاركة'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: AppTheme.albaikDeepNavy),
                      ),
                      onPressed: () {
                        _unfocusAll();
                        provider.shareReportPdf(_selectedReportMonth, _selectedReportYear);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: _isExporting 
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
                          : const Icon(Icons.telegram),
                      label: const Text('إرسال لتيليجرام'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0088cc), // لون تيليجرام
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: _isExporting ? null : () async {
                        _unfocusAll();
                        setState(() => _isExporting = true);
                        final success = await provider.sendReportPdfToTelegram(_selectedReportMonth, _selectedReportYear);
                        setState(() => _isExporting = false);
                        _showMessage(success ? 'تم إرسال التقرير بنجاح' : 'فشل الإرسال، تأكد من إعدادات البوت والإنترنت', isError: !success);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}