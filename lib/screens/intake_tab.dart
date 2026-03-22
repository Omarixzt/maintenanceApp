import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../providers/app_provider.dart';
import '../models/app_models.dart';
import '../theme/app_theme.dart';
import '../theme/custom_app_bar.dart';
import '../theme/app_animations.dart';

// استدعاء الملفات الجديدة
import 'intake_pickers.dart';
import 'intake_components.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AppProvider>(context, listen: false).loadDynamicData();
    });
  }

  void _onCostChanged() {
    setState(() {}); 
  }

  @override
  void dispose() {
    _costCtrl.removeListener(_onCostChanged);
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
    
    if (typedModel.isNotEmpty && _selectedFaultType == 'شاشة') {
      Provider.of<AppProvider>(context, listen: false)
          .fetchSuggestedPricesForModel(_selectedBrand?.name, typedModel);
    } else {
      Provider.of<AppProvider>(context, listen: false).clearSuggestedPrices();
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
      imageQuality: 50,      // تقليل الجودة لـ 50%
      maxWidth: 1080,        // تحديد أقصى عرض
      maxHeight: 1080,       // تحديد أقصى ارتفاع
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
      final provider = Provider.of<AppProvider>(context, listen: false);
      final newBrand = await provider.addBrand(newBrandName.toUpperCase());
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
        Provider.of<AppProvider>(context, listen: false).updateQuickPrice(qp, newPrice);
      }
    }
  }

  void _saveTicket() {
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
        Provider.of<AppProvider>(context, listen: false).addModelToBrand(_selectedBrand!, typedModel);
      }

      final newTicket = MaintenanceTicket()
        ..firebaseId = '${DateTime.now().millisecondsSinceEpoch}-${_phoneCtrl.text.hashCode}'
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

      Provider.of<AppProvider>(context, listen: false).addTicket(newTicket);

      _formKey.currentState!.reset();
      _costCtrl.clear();
      _customFaultCtrl.clear();
      _modelCtrl.clear();
      _nameCtrl.clear();
      _phoneCtrl.clear();

      Provider.of<AppProvider>(context, listen: false).currentSuggestedPrices.clear();

      setState(() {
        _selectedBrand = null;
        _deviceImageFile = null;
        _selectedFaultType = 'شاشة';
        _selectedDeliveryDate = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تسجيل الجهاز بنجاح')));
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
    final provider = Provider.of<AppProvider>(context);
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
                const SizedBox(height: 24),

                InkWell(
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
                const SizedBox(height: 16),

                _selectedBrand == null
                    ? Autocomplete<Map<String, dynamic>>(
                        displayStringForOption: (option) => option['model'] as String,
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text.isEmpty) {
                            return const Iterable<Map<String, dynamic>>.empty();
                          }
                          List<Map<String, dynamic>> allModels = [];
                          for (var brand in provider.brands) {
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
                    : InkWell(
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
                const SizedBox(height: 24),

                InkWell(
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

                if (_selectedFaultType == 'شاشة' && provider.currentSuggestedPrices.isNotEmpty) ...[
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.currentSuggestedPrices.length,
                    itemBuilder: (ctx, index) {
                      final sp = provider.currentSuggestedPrices[index];
                      int normalPrice = (sp.price + (sp.price * 0.8)).ceil();

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: AppTheme.albaikPureWhite,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2))
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
                                  child: Text(sp.partQuality, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.albaikDeepNavy), overflow: TextOverflow.ellipsis),
                                ),
                                const SizedBox(width: 8),
                                Text('المورد: ${sp.supplierName}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(color: AppTheme.albaikDeepNavy),
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
                                      child: Text('سعر الشاشة\n${sp.price}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, height: 1.3, fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.albaikRichRed,
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
                  children: provider.quickPrices.map((qp) {
                    final bool isSelected = double.tryParse(_costCtrl.text) == qp.price;
                    final String displayPrice = qp.price % 1 == 0 ? qp.price.toInt().toString() : qp.price.toStringAsFixed(1);

                    return InkWell(
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
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text('اضغط مطولاً على السعر السريع لتعديله', style: TextStyle(fontSize: 12, color: AppTheme.albaikDeepNavy.withOpacity(0.5))),
                ),
                
                const SizedBox(height: 32),

                InkWell(
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
                const SizedBox(height: 32),

                ElevatedButton(
                  onPressed: _saveTicket,
                  child: const Text('حفظ وإصدار التذكرة'),
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