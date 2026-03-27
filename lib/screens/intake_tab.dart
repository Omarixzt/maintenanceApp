import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart'; 
import '../providers/ticket_provider.dart';
import '../providers/inventory_provider.dart';
import '../providers/settings_provider.dart';
import '../models/app_models.dart';
import '../theme/app_theme.dart';
import '../theme/custom_app_bar.dart';
import '../theme/app_animations.dart';

import 'intake_pickers.dart';
import 'intake_components.dart';
import '../services/printer_service.dart';
import '../services/isar_service.dart';

class IntakeTab extends StatefulWidget {
  const IntakeTab({Key? key}) : super(key: key);

  @override
  State<IntakeTab> createState() => _IntakeTabState();
}

class _IntakeTabState extends State<IntakeTab> {
  final _formKey = GlobalKey<FormState>();
  final _costFieldKey = GlobalKey();

  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _customFaultCtrl = TextEditingController();
  final _costCtrl = TextEditingController();
  final _modelCtrl = TextEditingController();

  DeviceBrand? _selectedBrand;
  DateTime? _selectedDeliveryDate;
  String? _phoneWarning; // متغير جديد لتخزين رسالة التحذير الخاصة بالهاتف

  final List<Map<String, dynamic>> _faultTypes = [
    {'name': 'شاشة', 'icon': Icons.phone_iphone, 'color': AppTheme.albaikRichRed},
    {'name': 'قاعدة شحن', 'icon': Icons.usb, 'color': Colors.orange.shade700},
    {'name': 'بطارية', 'icon': Icons.battery_charging_full, 'color': Colors.green.shade700},
    {'name': 'سوفتوير', 'icon': Icons.system_update_alt, 'color': Colors.lightBlue.shade700},
    {'name': 'سماعة / مايك', 'icon': Icons.volume_up, 'color': Colors.deepPurple.shade700},
    {'name': 'فحص', 'icon': Icons.troubleshoot, 'color': Colors.amber.shade800},
    {'name': 'صيانة عامة', 'icon': Icons.build_circle_outlined, 'color': Colors.blueGrey},
    {'name': 'باك / شصي', 'icon': Icons.flip_to_back, 'color': Colors.brown},
    {'name': 'كاميرا', 'icon': Icons.camera_alt, 'color': Colors.teal},
    {'name': 'صيانة بورد', 'icon': Icons.memory, 'color': AppTheme.albaikRichRed},
    {'name': 'غير ذلك', 'icon': Icons.more_horiz, 'color': Colors.grey.shade700},
  ];
  String _selectedFaultType = 'شاشة';

  File? _deviceImageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _costCtrl.addListener(_onCostChanged);
    _phoneCtrl.addListener(_checkPhoneWarning); // إضافة المستمع اللحظي لرقم الهاتف
  }

  void _onCostChanged() {
    setState(() {}); 
  }

  // الدالة الجديدة للتحقق اللحظي من رقم الهاتف
  void _checkPhoneWarning() {
    final val = _phoneCtrl.text.trim();
    if (val.isEmpty) {
      if (_phoneWarning != null) setState(() => _phoneWarning = null);
      return;
    }
    
    bool hasLengthError = val.length != 10;
    bool hasPrefixError = !(val.startsWith('079') || val.startsWith('078') || val.startsWith('077'));
    
    String? newWarning;
    if (hasLengthError && hasPrefixError) {
      newWarning = 'تنبيه: الرقم ليس 10 أرقام ولا يبدأ بـ 079, 078, 077';
    } else if (hasLengthError) {
      newWarning = 'تنبيه: رقم الهاتف يجب أن يتكون من 10 أرقام';
    } else if (hasPrefixError) {
      newWarning = 'تنبيه: أرقام الهواتف الأردنية تبدأ بـ 079, 078, 077';
    }
    
    if (_phoneWarning != newWarning) {
      setState(() => _phoneWarning = newWarning);
    }
  }

  @override
  void dispose() {
    _costCtrl.removeListener(_onCostChanged);
    _phoneCtrl.removeListener(_checkPhoneWarning); // إزالة المستمع لتنظيف الذاكرة
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _customFaultCtrl.dispose();
    _costCtrl.dispose();
    _modelCtrl.dispose();
    super.dispose();
  }

  void _unfocusAll() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void _triggerPriceFetch() {
    final typedModel = _modelCtrl.text.trim().toUpperCase(); 
    
    if (typedModel.isNotEmpty) {
      Provider.of<InventoryProvider>(context, listen: false)
          .fetchSuggestedPricesForModel(_selectedBrand?.name, typedModel, _selectedFaultType);
    } else {
      Provider.of<InventoryProvider>(context, listen: false).clearSuggestedPrices();
    }
  }

  void _scrollToCostField() {
    if (_costFieldKey.currentContext != null) {
      Scrollable.ensureVisible(
        _costFieldKey.currentContext!,
        duration: AppAnimations.normal,
        curve: AppAnimations.smoothIn,
        alignment: 0.5, 
      );
    }
  }

  void _setToday() {
    _unfocusAll();
    setState(() {
      _selectedDeliveryDate = DateTime.now();
    });
  }

  void _setTomorrow() {
    _unfocusAll();
    setState(() {
      _selectedDeliveryDate = DateTime.now().add(const Duration(days: 1));
    });
  }

  Future<void> _pickDeliveryDate() async {
    _unfocusAll();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDeliveryDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDeliveryDate = picked;
      });
    }
  }

  Future<void> _takePicture() async {
    _unfocusAll();
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 1080,
      maxHeight: 1080,
    );
    if (photo != null) {
      setState(() {
        _deviceImageFile = File(photo.path);
      });
    }
  }

  Future<void> _handleNewBrand() async {
    final newBrandName = await _showInputDialog('إضافة شركة جديدة', 'اسم الشركة (مثل: Xiaomi)');
    if (newBrandName != null && newBrandName.isNotEmpty) {
      final inventoryProvider = Provider.of<InventoryProvider>(context, listen: false);
      final newBrand = await inventoryProvider.addBrand(newBrandName.toUpperCase());
      setState(() {
        _selectedBrand = newBrand;
        _modelCtrl.clear();
      });
      _triggerPriceFetch();
    }
  }

  Future<String?> _showInputDialog(String title, String hint) {
    TextEditingController ctrl = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.albaikDeepNavy)),
        content: TextField(
          controller: ctrl,
          decoration: InputDecoration(labelText: hint, prefixIcon: const Icon(Icons.edit_outlined)),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
            child: const Text('حفظ')
          ),
        ],
      ),
    );
  }

  Future<void> _editQuickPrice(QuickPrice qp) async {
    final newPriceStr = await _showInputDialog('تعديل السعر السريع', 'أدخل السعر الجديد');
    if (newPriceStr != null) {
      final newPrice = double.tryParse(newPriceStr);
      if (newPrice != null) {
        Provider.of<InventoryProvider>(context, listen: false).updateQuickPrice(qp, newPrice);
      }
    }
  }

  Future<void> _handlePostSave(MaintenanceTicket ticket) async {
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);

    // 1. السؤال الأول: طباعة وصل الزبون
    bool? printCustomer = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Row(
          children: [
            Icon(Icons.receipt_long, color: AppTheme.albaikRichRed),
            SizedBox(width: 8),
            Text('وصل الزبون', style: TextStyle(color: AppTheme.albaikDeepNavy, fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Text('هل تريد طباعة وصل استلام للزبون؟', style: TextStyle(fontSize: 16)),
        actions: [
          ScalePress(
            child: TextButton(
              onPressed: () => Navigator.pop(ctx, false), 
              child: const Text('تخطي', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))
            ),
          ),
          ScalePress(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.albaikRichRed),
              onPressed: () => Navigator.pop(ctx, true), 
              child: const Text('طباعة')
            ),
          ),
        ],
      ),
    );

    if (printCustomer == true && mounted) {
      await PrinterService.printWithFallbackDialog(
        context: context,
        ticket: ticket,
        macAddress: settingsProvider.printerMac,
        isCustomerCopy: true,
      );
      await Future.delayed(const Duration(seconds: 2));
    }

    // 2. السؤال الثاني: طباعة وصل المحل
    if (!mounted) return;
    bool? printShop = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Row(
          children: [
            Icon(Icons.storefront, color: AppTheme.albaikDeepNavy),
            SizedBox(width: 8),
            Text('وصل المحل', style: TextStyle(color: AppTheme.albaikDeepNavy, fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Text('هل تريد طباعة ملصق/وصل للمحل للصقه على الجهاز؟', style: TextStyle(fontSize: 16)),
        actions: [
          ScalePress(
            child: TextButton(
              onPressed: () => Navigator.pop(ctx, false), 
              child: const Text('تخطي', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))
            ),
          ),
          ScalePress(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.albaikDeepNavy),
              onPressed: () => Navigator.pop(ctx, true), 
              child: const Text('طباعة')
            ),
          ),
        ],
      ),
    );

    if (printShop == true && mounted) {
      await PrinterService.printWithFallbackDialog(
        context: context,
        ticket: ticket,
        macAddress: settingsProvider.printerMac,
        isCustomerCopy: false,
      );
      await Future.delayed(const Duration(seconds: 1));
    }

    // 3. أنيميشن النجاح وتصفير الشاشة
    if (mounted) {
      _showSuccessAnimationAndReset();
    }
  }

  void _showSuccessAnimationAndReset() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_outline, color: Colors.green, size: 70)
                  .animate()
                  .scale(duration: const Duration(milliseconds: 500), curve: Curves.elasticOut)
                  .shimmer(delay: const Duration(milliseconds: 300)), 

              const SizedBox(height: 16),
              
              const Text(
                'تم حفظ الوصل بنجاح!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppTheme.albaikDeepNavy,
                ),
              ).animate()
                  .fadeIn(delay: const Duration(milliseconds: 200))
                  .slideY(begin: 0.2, end: 0, curve: Curves.easeInOutBack),
            ],
          ),
        ),
      ),
    );

    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        Navigator.of(context).pop(); 

        _formKey.currentState?.reset();
        setState(() {
          _nameCtrl.clear();
          _phoneCtrl.clear();
          _customFaultCtrl.clear();
          _costCtrl.clear();
          _modelCtrl.clear();
          _selectedBrand = null;
          _selectedDeliveryDate = null;
          _deviceImageFile = null;
          _selectedFaultType = 'شاشة';
          _phoneWarning = null; // تصفير حقل التنبيه
        });
        
        Provider.of<InventoryProvider>(context, listen: false).clearSuggestedPrices();
      }
    });
  }

  void _saveTicket() async {
    _unfocusAll();
    
    if (_selectedDeliveryDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('يرجى تحديد موعد التسليم المتوقع، هذا الحقل إجباري'),
        backgroundColor: AppTheme.albaikRichRed,
      ));
      return;
    }

    final typedModel = _modelCtrl.text.trim().toUpperCase();

    if (_formKey.currentState!.validate() && _selectedBrand != null && typedModel.isNotEmpty) {
      String finalFault = _selectedFaultType == 'غير ذلك' ? _customFaultCtrl.text : _selectedFaultType;

      if (finalFault.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('يرجى كتابة وصف العطل')));
        return;
      }

      if (!_selectedBrand!.models.contains(typedModel)) {
        Provider.of<InventoryProvider>(context, listen: false).addModelToBrand(_selectedBrand!, typedModel);
      }

      final newTicket = MaintenanceTicket()
        ..customerName = _nameCtrl.text.trim()
        ..phoneNumber = _phoneCtrl.text.trim()
        ..deviceType = _selectedBrand!.name
        ..deviceModel = typedModel
        ..faultDescription = finalFault
        ..status = 'Waiting' 
        ..receivedDate = DateTime.now().toIso8601String()
        ..expectedDeliveryDate = _selectedDeliveryDate!.toIso8601String()
        ..expectedCost = double.tryParse(_costCtrl.text) ?? 0.0
        ..imagePath = _deviceImageFile?.path
        ..isArchived = false
        ..syncStatus = 0;

      Provider.of<TicketProvider>(context, listen: false).addTicket(newTicket);

      await _handlePostSave(newTicket);

    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('يرجى إكمال البيانات المطلوبة')));
    }
  }

  void _showBrandPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => BrandPickerSheet(
        selectedBrand: _selectedBrand,
        onBrandSelected: (brand) {
          setState(() {
            _selectedBrand = brand;
            _modelCtrl.clear(); 
          });
          _triggerPriceFetch();
          Navigator.pop(context);
        },
        onAddNewBrand: () {
          Navigator.pop(context);
          _handleNewBrand();
        },
      ),
    );
  }

  void _showModelPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ModelPickerSheet(
        selectedBrand: _selectedBrand,
        onModelSelected: (model) {
          setState(() {
            _modelCtrl.text = model;
          });
          _triggerPriceFetch();
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showFaultPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => FaultPickerSheet(
        faultTypes: _faultTypes,
        selectedFaultType: _selectedFaultType,
        onFaultSelected: (fault) {
          setState(() => _selectedFaultType = fault);
          _triggerPriceFetch();
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final inventoryProvider = Provider.of<InventoryProvider>(context);
    final currentFaultData = _faultTypes.firstWhere((f) => f['name'] == _selectedFaultType, orElse: () => _faultTypes.last);

    bool isTodaySelected = _selectedDeliveryDate != null && DateFormat('yyyy-MM-dd').format(_selectedDeliveryDate!) == DateFormat('yyyy-MM-dd').format(DateTime.now());
    bool isTomorrowSelected = _selectedDeliveryDate != null && DateFormat('yyyy-MM-dd').format(_selectedDeliveryDate!) == DateFormat('yyyy-MM-dd').format(DateTime.now().add(const Duration(days: 1)));
    bool isOtherDateSelected = _selectedDeliveryDate != null && !isTodaySelected && !isTomorrowSelected;

    return Scaffold(
      appBar: const CustomAppBar(title: 'استلام جهاز جديد'),
      body: GestureDetector(
        onTap: _unfocusAll,
        behavior: HitTestBehavior.opaque,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(labelText: 'اسم العميل', prefixIcon: Icon(Icons.person_outline)),
                  validator: (val) => val!.isEmpty ? 'مطلوب' : null,
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'رقم الهاتف', prefixIcon: Icon(Icons.phone_outlined)),
                  validator: (val) => val!.isEmpty ? 'مطلوب' : null,
                ),
                // رسالة التنبيه اللحظية أسفل حقل رقم الهاتف
                if (_phoneWarning != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8, right: 12),
                    child: Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, color: Colors.orange.shade700, size: 16),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            _phoneWarning!, 
                            style: TextStyle(color: Colors.orange.shade700, fontSize: 12, fontWeight: FontWeight.bold)
                          ),
                        ),
                      ],
                    ),
                  ),
                
                const SizedBox(height: 24),

                ScalePress(
                  child: InkWell(
                    onTap: () {
                      _unfocusAll();
                      _showBrandPicker(context);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: InputDecorator(
                      decoration: const InputDecoration(labelText: 'نوع الجهاز (الشركة)', prefixIcon: Icon(Icons.business_outlined)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              _selectedBrand?.name ?? 'اضغط لاختيار الشركة',
                              style: TextStyle(
                                color: _selectedBrand == null ? Colors.grey[500] : AppTheme.albaikDeepNavy,
                                fontSize: 16,
                                fontWeight: _selectedBrand == null ? FontWeight.normal : FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(Icons.keyboard_arrow_down_rounded, color: AppTheme.albaikDeepNavy.withOpacity(0.4)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                _selectedBrand == null
                    ? Autocomplete<Map<String, dynamic>>(
                        displayStringForOption: (option) => option['model'] as String,
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text.isEmpty) {
                            return const Iterable<Map<String, dynamic>>.empty();
                          }
                          List<Map<String, dynamic>> allModels = [];
                          for (var brand in inventoryProvider.brands) {
                            for (var model in brand.models) {
                              allModels.add({'brand': brand, 'model': model});
                            }
                          }
                          return allModels.where((option) {
                            final model = option['model'] as String;
                            return model.toLowerCase().contains(textEditingValue.text.toLowerCase());
                          });
                        },
                        onSelected: (Map<String, dynamic> selection) {
                          setState(() {
                            _selectedBrand = selection['brand'] as DeviceBrand;
                            _modelCtrl.text = selection['model'] as String;
                          });
                          _triggerPriceFetch();
                          _unfocusAll();
                        },
                        fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                          return TextFormField(
                            controller: controller,
                            focusNode: focusNode,
                            decoration: InputDecoration(
                              labelText: 'بحث عن الموديل (جميع الشركات)',
                              prefixIcon: const Icon(Icons.search, color: AppTheme.albaikDeepNavy),
                              suffixIcon: controller.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear, size: 20),
                                      onPressed: () {
                                        controller.clear();
                                        _modelCtrl.clear();
                                        _triggerPriceFetch();
                                      },
                                    )
                                  : null,
                            ),
                            onChanged: (val) {
                              _modelCtrl.text = val;
                            },
                            onEditingComplete: () {
                              _triggerPriceFetch();
                              focusNode.unfocus();
                            },
                          );
                        },
                      )
                    : ScalePress(
                        child: InkWell(
                          onTap: () {
                            _unfocusAll();
                            _showModelPicker(context);
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: InputDecorator(
                            decoration: const InputDecoration(labelText: 'موديل الجهاز', prefixIcon: Icon(Icons.smartphone_outlined)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    _modelCtrl.text.isEmpty ? 'اضغط لاختيار الموديل' : _modelCtrl.text,
                                    style: TextStyle(
                                      color: _modelCtrl.text.isEmpty ? Colors.grey[500] : AppTheme.albaikDeepNavy,
                                      fontSize: 16,
                                      fontWeight: _modelCtrl.text.isEmpty ? FontWeight.normal : FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Icon(Icons.keyboard_arrow_down_rounded, color: AppTheme.albaikDeepNavy.withOpacity(0.4)),
                              ],
                            ),
                          ),
                        ),
                      ),
                const SizedBox(height: 24),

                ScalePress(
                  child: InkWell(
                    onTap: () {
                      _unfocusAll();
                      _showFaultPicker(context);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'نوع العطل',
                        prefixIcon: Icon(currentFaultData['icon'], color: AppTheme.albaikRichRed),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              _selectedFaultType,
                              style: const TextStyle(fontSize: 16, color: AppTheme.albaikDeepNavy, fontWeight: FontWeight.w600),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(Icons.keyboard_arrow_down_rounded, color: AppTheme.albaikDeepNavy.withOpacity(0.4)),
                        ],
                      ),
                    ),
                  ),
                ),

                if (_selectedFaultType == 'غير ذلك') ...[
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _customFaultCtrl,
                    decoration: const InputDecoration(labelText: 'أدخل تفاصيل العطل يدوياً', prefixIcon: Icon(Icons.build_outlined)),
                  ),
                ],
                const SizedBox(height: 24),

                InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'موعد التسليم المتوقع *',
                    prefixIcon: Icon(
                      Icons.calendar_month, 
                      color: _selectedDeliveryDate != null ? AppTheme.albaikRichRed : AppTheme.albaikDeepNavy.withOpacity(0.5)
                    ),
                  ),
                  child: AnimatedSwitcher(
                    duration: AppAnimations.normal,
                    transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
                    child: Row(
                      key: ValueKey<String>(_selectedDeliveryDate?.toIso8601String() ?? 'null'),
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedDeliveryDate != null 
                              ? DateFormat('yyyy-MM-dd').format(_selectedDeliveryDate!)
                              : 'يرجى تحديد موعد التسليم',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: _selectedDeliveryDate != null ? FontWeight.bold : FontWeight.normal,
                            color: _selectedDeliveryDate != null ? AppTheme.albaikDeepNavy : Colors.red.shade700,
                          ),
                        ),
                        if (_selectedDeliveryDate != null)
                          GestureDetector(
                            onTap: () => setState(() => _selectedDeliveryDate = null),
                            child: const Icon(Icons.clear, color: Colors.grey, size: 20),
                          )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    AnimatedDateButton(
                      label: 'اليوم',
                      isSelected: isTodaySelected,
                      onTap: _setToday,
                    ),
                    const SizedBox(width: 8),
                    AnimatedDateButton(
                      label: 'غداً',
                      isSelected: isTomorrowSelected,
                      onTap: _setTomorrow,
                    ),
                    const SizedBox(width: 8),
                    AnimatedDateButton(
                      label: 'تاريخ آخر',
                      icon: Icons.date_range,
                      isSelected: isOtherDateSelected,
                      onTap: _pickDeliveryDate,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                if (inventoryProvider.currentSuggestedPrices.isNotEmpty) ...[
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: inventoryProvider.currentSuggestedPrices.length,
                    itemBuilder: (ctx, index) {
                      final sp = inventoryProvider.currentSuggestedPrices[index];
                      int normalPrice = (sp.price + (sp.price * 0.8)).ceil();
                      
                      bool isLocalInventory = sp.supplierName.contains('المخزون المحلي');

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: isLocalInventory ? Colors.green.shade50 : AppTheme.albaikPureWhite,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isLocalInventory ? Colors.green.shade400 : Colors.grey.shade200, 
                            width: isLocalInventory ? 2 : 1
                          ),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 2))
                          ],
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(sp.partQuality, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isLocalInventory ? Colors.green.shade800 : AppTheme.albaikDeepNavy), overflow: TextOverflow.ellipsis),
                                ),
                                const SizedBox(width: 8),
                                Text(sp.supplierName, style: TextStyle(color: isLocalInventory ? Colors.green.shade800 : Colors.grey, fontSize: 12, fontWeight: isLocalInventory ? FontWeight.bold : FontWeight.normal)),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: ScalePress(
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(color: isLocalInventory ? Colors.green.shade700 : AppTheme.albaikDeepNavy),
                                        foregroundColor: isLocalInventory ? Colors.green.shade700 : AppTheme.albaikDeepNavy,
                                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 2),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      ),
                                      onPressed: () {
                                        _unfocusAll();
                                        _costCtrl.text = sp.price.toString();
                                        _scrollToCostField(); 
                                      },
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text('التكلفة عليك\n${sp.price}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, height: 1.3, fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ScalePress(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isLocalInventory ? Colors.green.shade700 : AppTheme.albaikRichRed,
                                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 2),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      ),
                                      onPressed: () {
                                        _unfocusAll();
                                        _costCtrl.text = normalPrice.toString();
                                        _scrollToCostField(); 
                                      },
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text('السعر المقترح\n$normalPrice', textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, height: 1.3, fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                ],

                TextFormField(
                  key: _costFieldKey,
                  controller: _costCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'التكلفة الإجمالية المتوقعة', prefixIcon: Icon(Icons.attach_money_rounded)),
                ),

                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: inventoryProvider.quickPrices.map((qp) {
                    final bool isSelected = double.tryParse(_costCtrl.text) == qp.price;
                    final String displayPrice = qp.price % 1 == 0 ? qp.price.toInt().toString() : qp.price.toStringAsFixed(1);

                    return ScalePress(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          _unfocusAll();
                          _costCtrl.text = displayPrice;
                        },
                        onLongPress: () {
                          _unfocusAll();
                          _editQuickPrice(qp);
                        },
                        child: AnimatedContainer(
                          duration: AppAnimations.fast,
                          curve: AppAnimations.smoothIn,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected ? AppTheme.albaikRichRed : AppTheme.albaikPureWhite,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected ? AppTheme.albaikRichRed : Colors.grey.shade200, 
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Text(
                            displayPrice,
                            style: TextStyle(
                              fontWeight: FontWeight.w600, 
                              color: isSelected ? AppTheme.albaikPureWhite : AppTheme.albaikDeepNavy,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text('اضغط مطولاً على السعر السريع لتعديله', style: TextStyle(fontSize: 12, color: AppTheme.albaikDeepNavy.withOpacity(0.5))),
                ),
                
                const SizedBox(height: 32),

                ScalePress(
                  child: InkWell(
                    onTap: _takePicture,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: _deviceImageFile == null ? AppTheme.albaikPureWhite : AppTheme.albaikDeepNavy.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppTheme.albaikDeepNavy.withOpacity(0.3),
                          width: 2,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            _deviceImageFile == null ? Icons.camera_alt_outlined : Icons.check_circle_outline,
                            size: 32,
                            color: AppTheme.albaikDeepNavy.withOpacity(0.7),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _deviceImageFile == null ? 'التقاط صورة لحالة الجهاز' : 'تم التقاط الصورة بنجاح (اضغط لتغييرها)',
                            style: const TextStyle(
                              color: AppTheme.albaikDeepNavy,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                ScalePress(
                  child: ElevatedButton(
                    onPressed: _saveTicket,
                    child: const Text('حفظ وإصدار الوصل'),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ScalePress extends StatefulWidget {
  final Widget child;
  const ScalePress({Key? key, required this.child}) : super(key: key);

  @override
  State<ScalePress> createState() => _ScalePressState();
}

class _ScalePressState extends State<ScalePress> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        if (mounted) setState(() => _isPressed = true);
      },
      onPointerUp: (_) {
        if (mounted) setState(() => _isPressed = false);
      },
      onPointerCancel: (_) {
        if (mounted) setState(() => _isPressed = false);
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.94 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}