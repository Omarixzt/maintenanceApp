import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import '../providers/app_provider.dart';
import '../models/app_models.dart';
import '../theme/app_theme.dart';
import '../theme/custom_app_bar.dart'; // مسار الـ AppBar المخصص

class IntakeTab extends StatefulWidget {
  const IntakeTab({Key? key}) : super(key: key);

  @override
  State<IntakeTab> createState() => _IntakeTabState();
}

class _IntakeTabState extends State<IntakeTab> {
  final _formKey = GlobalKey<FormState>();
  
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _customFaultCtrl = TextEditingController();
  final _costCtrl = TextEditingController();

  DeviceBrand? _selectedBrand;
  String? _selectedModel;
  
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AppProvider>(context, listen: false).loadDynamicData();
    });
  }

  void _triggerPriceFetch() {
    if (_selectedModel != null && _selectedFaultType == 'شاشة') {
      Provider.of<AppProvider>(context, listen: false).fetchSuggestedPricesForModel(_selectedModel!);
    } else {
      Provider.of<AppProvider>(context, listen: false).currentSuggestedPrices.clear();
    }
  }

  Future<void> _takePicture() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
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
        _selectedModel = null;
      });
    }
  }

  Future<void> _handleNewModel() async {
    if (_selectedBrand == null) return;
    final newModelName = await _showInputDialog('إضافة موديل جديد', 'اسم الموديل (مثل: Redmi Note 12)');
    if (newModelName != null && newModelName.isNotEmpty) {
      final provider = Provider.of<AppProvider>(context, listen: false);
      await provider.addModelToBrand(_selectedBrand!, newModelName.toUpperCase());
      setState(() {
        _selectedModel = newModelName.toUpperCase();
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
    if (_formKey.currentState!.validate() && _selectedBrand != null && _selectedModel != null) {
      String finalFault = _selectedFaultType == 'غير ذلك' ? _customFaultCtrl.text : _selectedFaultType;
      
      if (finalFault.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('يرجى كتابة وصف العطل')));
        return;
      }

      final newTicket = MaintenanceTicket()
        ..firebaseId = DateTime.now().millisecondsSinceEpoch.toString()
        ..customerName = _nameCtrl.text
        ..phoneNumber = _phoneCtrl.text
        ..deviceType = _selectedBrand!.name
        ..deviceModel = _selectedModel!
        ..faultDescription = finalFault
        ..receivedDate = DateTime.now().toIso8601String()
        ..expectedCost = double.tryParse(_costCtrl.text) ?? 0.0
        ..imagePath = _deviceImageFile?.path;

      Provider.of<AppProvider>(context, listen: false).addTicket(newTicket);
      
      _formKey.currentState!.reset();
      _costCtrl.clear();
      _customFaultCtrl.clear();
      setState(() {
        _selectedBrand = null;
        _selectedModel = null;
        _deviceImageFile = null;
        _selectedFaultType = 'شاشة';
      });
      Provider.of<AppProvider>(context, listen: false).currentSuggestedPrices.clear();
      
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم حفظ التذكرة بنجاح')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('يرجى تعبئة كافة الحقول المطلوبة بما فيها الشركة والموديل')));
    }
  }

  void _showBrandPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, 
      builder: (sheetContext) {
        return Consumer<AppProvider>(
          builder: (context, provider, child) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.70,
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const Text(
                    'اختر الشركة',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.albaikDeepNavy),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ReorderableGridView.builder(
                      dragStartDelay: const Duration(seconds: 3), 
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, 
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.85, 
                      ),
                      itemCount: provider.brands.length,
                      onReorder: (oldIndex, newIndex) {
                        provider.reorderBrands(oldIndex, newIndex);
                      },
                      itemBuilder: (context, index) {
                        final brand = provider.brands[index];
                        final isSelected = _selectedBrand?.name == brand.name;
                        
                        return InkWell(
                          key: ValueKey(brand.name), 
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            setState(() {
                              _selectedBrand = brand;
                              _selectedModel = null; 
                            });
                            _triggerPriceFetch();
                            Navigator.pop(context); 
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: isSelected ? AppTheme.albaikDeepNavy.withOpacity(0.05) : AppTheme.albaikPureWhite,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected ? AppTheme.albaikDeepNavy : Colors.grey.shade200,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _getBrandLogo(brand.name),
                                const SizedBox(height: 12),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                  child: Text(
                                    brand.name,
                                    style: TextStyle(
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                      fontSize: 13,
                                      color: isSelected ? AppTheme.albaikDeepNavy : AppTheme.albaikDeepNavy.withOpacity(0.8),
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.add_circle_outline),
                      label: const Text('إضافة شركة جديدة'),
                      onPressed: () {
                        Navigator.pop(context); 
                        _handleNewBrand(); 
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showFaultPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, 
      builder: (sheetContext) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.55,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 12,
                decoration: const BoxDecoration(
                  color: AppTheme.albaikDeepNavy,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
              ),
              Container(
                width: double.infinity,
                height: 6,
                color: AppTheme.albaikRichRed,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const Text(
                      'اختر نوع العطل',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.albaikDeepNavy),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: _faultTypes.length,
                    itemBuilder: (context, index) {
                      final fault = _faultTypes[index];
                      final isSelected = _selectedFaultType == fault['name'];
                      final faultColor = fault['color'] as Color;
                      
                      return InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          setState(() => _selectedFaultType = fault['name']);
                          _triggerPriceFetch();
                          Navigator.pop(context);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: isSelected ? faultColor.withOpacity(0.1) : AppTheme.albaikPureWhite,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected ? AppTheme.albaikRichRed : Colors.grey.shade200,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                fault['icon'],
                                size: 28,
                                color: isSelected ? AppTheme.albaikRichRed : AppTheme.albaikDeepNavy.withOpacity(0.7),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: Text(
                                  fault['name'],
                                  style: TextStyle(
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                    fontSize: 11,
                                    color: isSelected ? AppTheme.albaikRichRed : AppTheme.albaikDeepNavy,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _getBrandLogo(String brandName) {
    String cleanName = brandName.toLowerCase().replaceAll(' ', '');
    return Image.asset(
      'lib/assets/$cleanName.png',
      width: 45,
      height: 45,
      errorBuilder: (context, error, stackTrace) => _fallbackLogo(brandName),
    );
  }

  Widget _fallbackLogo(String brandName) {
    return CircleAvatar(
      radius: 22,
      backgroundColor: AppTheme.albaikDeepNavy.withOpacity(0.08),
      child: Text(
        brandName.isNotEmpty ? brandName[0].toUpperCase() : '?',
        style: const TextStyle(
          color: AppTheme.albaikDeepNavy, 
          fontWeight: FontWeight.bold, 
          fontSize: 20,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final currentFaultData = _faultTypes.firstWhere((f) => f['name'] == _selectedFaultType, orElse: () => _faultTypes.last);

    return Scaffold(
      // تم استدعاء الشريط العلوي المخصص هنا بسطر واحد
      appBar: const CustomAppBar(title: 'استلام جهاز جديد'),
      body: SingleChildScrollView(
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
              
              GestureDetector(
                onTap: () => _showBrandPicker(context), 
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'نوع الجهاز (الشركة)', prefixIcon: Icon(Icons.business_outlined)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedBrand?.name ?? 'اضغط لاختيار الشركة',
                        style: TextStyle(
                          color: _selectedBrand == null ? Colors.grey[500] : AppTheme.albaikDeepNavy,
                          fontSize: 16,
                          fontWeight: _selectedBrand == null ? FontWeight.normal : FontWeight.w600,
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_down_rounded, color: AppTheme.albaikDeepNavy.withOpacity(0.4)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String?>(
                value: _selectedModel,
                decoration: const InputDecoration(labelText: 'موديل الجهاز', prefixIcon: Icon(Icons.smartphone_outlined)),
                icon: Icon(Icons.keyboard_arrow_down_rounded, color: AppTheme.albaikDeepNavy.withOpacity(0.4)),
                dropdownColor: AppTheme.albaikPureWhite,
                borderRadius: BorderRadius.circular(16),
                items: _selectedBrand == null ? [] : [
                  ..._selectedBrand!.models.map((m) => DropdownMenuItem(value: m, child: Text(m, style: const TextStyle(fontWeight: FontWeight.w500, color: AppTheme.albaikDeepNavy)))),
                  const DropdownMenuItem(value: null, child: Text('+ إضافة موديل جديد', style: TextStyle(color: AppTheme.albaikDeepNavy, fontWeight: FontWeight.bold))),
                ],
                onChanged: _selectedBrand == null ? null : (val) {
                  if (val == null) {
                    _handleNewModel();
                  } else {
                    setState(() => _selectedModel = val);
                    _triggerPriceFetch();
                  }
                },
              ),
              const SizedBox(height: 24),

              GestureDetector(
                onTap: () => _showFaultPicker(context),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'نوع العطل', 
                    prefixIcon: Icon(currentFaultData['icon'], color: AppTheme.albaikRichRed),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedFaultType,
                        style: const TextStyle(fontSize: 16, color: AppTheme.albaikDeepNavy, fontWeight: FontWeight.w600),
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

              if (_selectedFaultType == 'شاشة' && provider.currentSuggestedPrices.isNotEmpty) ...[
                const Text('الأسعار المتوفرة للشاشات:', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.albaikDeepNavy, fontSize: 16)),
                const SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.currentSuggestedPrices.length,
                  itemBuilder: (ctx, index) {
                    final sp = provider.currentSuggestedPrices[index];
                    int finalSuggestedPrice = (sp.price + 70).ceil(); 

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
                              Text(sp.partQuality, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.albaikDeepNavy)),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppTheme.albaikDeepNavy.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text('المورد: ${sp.supplierName}', style: const TextStyle(color: AppTheme.albaikDeepNavy, fontSize: 12)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    _costCtrl.text = sp.price.toStringAsFixed(1);
                                  },
                                  child: Text('التكلفة: ${sp.price}'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.albaikRichRed,
                                  ),
                                  onPressed: () {
                                    _costCtrl.text = finalSuggestedPrice.toString();
                                  },
                                  child: Text('المقترح: $finalSuggestedPrice'),
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
                controller: _costCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'التكلفة الإجمالية', prefixIcon: Icon(Icons.attach_money_rounded)),
              ),
              
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: provider.quickPrices.map((qp) {
                  return InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      _costCtrl.text = qp.price.toStringAsFixed(1);
                    },
                    onLongPress: () => _editQuickPrice(qp),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppTheme.albaikPureWhite,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.albaikRichRed),
                      ),
                      child: Text(
                        qp.price.toStringAsFixed(1),
                        style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.albaikDeepNavy),
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
    );
  }
}