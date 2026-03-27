import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/inventory_provider.dart';
import '../models/app_models.dart';
import '../theme/custom_app_bar.dart';
import '../theme/app_theme.dart';
import '../theme/app_animations.dart';
import 'intake_pickers.dart';

class InventoryTab extends StatefulWidget {
  const InventoryTab({Key? key}) : super(key: key);

  @override
  State<InventoryTab> createState() => _InventoryTabState();
}

class _InventoryTabState extends State<InventoryTab> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  final TextEditingController _partNameCtrl = TextEditingController();
  final TextEditingController _costCtrl = TextEditingController();
  final TextEditingController _qtyCtrl = TextEditingController(text: '1');
  
  DeviceBrand? _selectedBrand;
  String? _selectedModel;
  String? _selectedPartType;

  final List<Map<String, dynamic>> _faultTypes = [
    {'name': 'شاشة', 'icon': Icons.phone_iphone, 'color': AppTheme.albaikRichRed},
    {'name': 'قاعدة شحن', 'icon': Icons.usb, 'color': Colors.orange.shade700},
    {'name': 'بطارية', 'icon': Icons.battery_charging_full, 'color': Colors.green.shade700},
    {'name': 'سوفتوير', 'icon': Icons.system_update_alt, 'color': Colors.lightBlue.shade700},
    {'name': 'سماعة / مايك', 'icon': Icons.volume_up, 'color': Colors.deepPurple.shade700},
    {'name': 'باك / شصي', 'icon': Icons.flip_to_back, 'color': Colors.brown},
    {'name': 'كاميرا', 'icon': Icons.camera_alt, 'color': Colors.teal},
    {'name': 'صيانة بورد', 'icon': Icons.memory, 'color': AppTheme.albaikRichRed},
    {'name': 'غير ذلك', 'icon': Icons.more_horiz, 'color': Colors.grey.shade700},
  ];

  @override
  void dispose() {
    _partNameCtrl.dispose();
    _costCtrl.dispose();
    _qtyCtrl.dispose();
    super.dispose();
  }

  void _unfocusAll() => FocusManager.instance.primaryFocus?.unfocus();

  void _showPartFormDialog(BuildContext context, InventoryProvider provider, {LocalPart? existingPart}) {
    final isEditMode = existingPart != null;

    if (isEditMode) {
      _partNameCtrl.text = existingPart.partName;
      _selectedModel = existingPart.deviceModel;
      _selectedPartType = existingPart.partType;
      _costCtrl.text = existingPart.costPrice.toString();
      _qtyCtrl.text = existingPart.quantity.toString();
      try {
        _selectedBrand = provider.brands.firstWhere((b) => b.name == existingPart.deviceBrand);
      } catch (_) {
        _selectedBrand = DeviceBrand()..name = existingPart.deviceBrand..models = [existingPart.deviceModel];
      }
    } else {
      _selectedBrand = null;
      _selectedModel = null;
      _selectedPartType = null;
      _partNameCtrl.clear();
      _costCtrl.clear();
      _qtyCtrl.text = '1';
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setSheetState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: const BoxDecoration(
              color: AppTheme.albaikPureWhite,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: double.infinity, height: 12,
                  decoration: const BoxDecoration(color: AppTheme.albaikDeepNavy, borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
                ),
                Container(width: double.infinity, height: 6, color: AppTheme.albaikRichRed),
                
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(isEditMode ? 'تعديل بيانات القطعة' : 'إضافة قطعة للمخزون', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.albaikDeepNavy)),
                              if (isEditMode)
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: AppTheme.albaikRichRed),
                                  onPressed: () async {
                                    _unfocusAll();
                                    bool? confirmDelete = await showDialog<bool>(
                                      context: context,
                                      builder: (deleteCtx) => AlertDialog(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                        title: const Text('تأكيد الحذف', style: TextStyle(color: AppTheme.albaikRichRed, fontWeight: FontWeight.bold)),
                                        content: const Text('هل أنت متأكد أنك تريد حذف هذه القطعة من المخزون بشكل نهائي؟'),
                                        actions: [
                                          TextButton(onPressed: () => Navigator.pop(deleteCtx, false), child: const Text('إلغاء')),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.albaikRichRed),
                                            onPressed: () => Navigator.pop(deleteCtx, true),
                                            child: const Text('حذف نهائي'),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (confirmDelete == true) {
                                      provider.deleteInventoryPart(existingPart!);
                                      if (ctx.mounted) Navigator.pop(ctx);
                                      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم حذف القطعة بنجاح ومزامنتها')));
                                    }
                                  },
                                ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          TextFormField(
                            controller: _partNameCtrl,
                            decoration: const InputDecoration(labelText: 'اسم / وصف القطعة (مثال: شاشة أصلية وكالة)', prefixIcon: Icon(Icons.label_outline)),
                            validator: (val) => val!.isEmpty ? 'يرجى إدخال اسم القطعة' : null,
                          ),
                          const SizedBox(height: 16),

                          InkWell(
                            onTap: () {
                              _unfocusAll();
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (sheetContext) => BrandPickerSheet(
                                  selectedBrand: _selectedBrand,
                                  onBrandSelected: (brand) {
                                    setSheetState(() {
                                      _selectedBrand = brand;
                                      _selectedModel = null;
                                    });
                                    Navigator.pop(context);
                                  },
                                  onAddNewBrand: () => Navigator.pop(context), 
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: InputDecorator(
                              decoration: const InputDecoration(labelText: 'الشركة المصنعة', prefixIcon: Icon(Icons.business_outlined)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(_selectedBrand?.name ?? 'اضغط لاختيار الشركة', style: TextStyle(color: _selectedBrand == null ? Colors.grey : AppTheme.albaikDeepNavy, fontWeight: FontWeight.bold)),
                                  const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          InkWell(
                            onTap: _selectedBrand == null ? null : () {
                              _unfocusAll();
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) => ModelPickerSheet(
                                  selectedBrand: _selectedBrand,
                                  onModelSelected: (model) {
                                    setSheetState(() => _selectedModel = model);
                                    Navigator.pop(context);
                                  },
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: InputDecorator(
                              decoration: InputDecoration(labelText: 'موديل الجهاز', prefixIcon: Icon(Icons.smartphone, color: _selectedBrand == null ? Colors.grey : AppTheme.albaikDeepNavy)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(_selectedModel ?? 'اضغط لاختيار الموديل', style: TextStyle(color: _selectedModel == null ? Colors.grey : AppTheme.albaikDeepNavy, fontWeight: FontWeight.bold)),
                                  const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          InkWell(
                            onTap: () {
                              _unfocusAll();
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (sheetContext) => FaultPickerSheet(
                                  faultTypes: _faultTypes,
                                  selectedFaultType: _selectedPartType ?? '',
                                  onFaultSelected: (fault) {
                                    setSheetState(() => _selectedPartType = fault);
                                    Navigator.pop(context);
                                  },
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: InputDecorator(
                              decoration: const InputDecoration(labelText: 'تصنيف القطعة (لربطها بنوع العطل)', prefixIcon: Icon(Icons.build_circle_outlined)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(_selectedPartType ?? 'اضغط لاختيار التصنيف', style: TextStyle(color: _selectedPartType == null ? Colors.grey : AppTheme.albaikDeepNavy, fontWeight: FontWeight.bold)),
                                  const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _costCtrl,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(labelText: 'التكلفة', prefixIcon: Icon(Icons.attach_money)),
                                  validator: (val) => val!.isEmpty ? '*' : null,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextFormField(
                                  controller: _qtyCtrl,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                  decoration: InputDecoration(
                                    labelText: 'الكمية',
                                    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 0), // تقليل الهوامش الداخلية لراحة الأزرار
                                    prefixIcon: IconButton(
                                      icon: const Icon(Icons.remove_circle_outline, color: AppTheme.albaikRichRed),
                                      onPressed: () async {
                                        _unfocusAll();
                                        int currentQty = int.tryParse(_qtyCtrl.text) ?? 0;
                                        if (currentQty > 1) {
                                          setSheetState(() => _qtyCtrl.text = (currentQty - 1).toString());
                                        } else if (currentQty <= 1 && isEditMode) {
                                          bool? confirmDelete = await showDialog<bool>(
                                            context: context,
                                            builder: (deleteCtx) => AlertDialog(
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                              title: const Text('نفاد الكمية', style: TextStyle(color: AppTheme.albaikRichRed, fontWeight: FontWeight.bold)),
                                              content: const Text('وصول الكمية إلى 0 يعني نفاد القطعة. هل تريد حذفها من المخزون بشكل نهائي؟'),
                                              actions: [
                                                TextButton(onPressed: () => Navigator.pop(deleteCtx, false), child: const Text('إلغاء')),
                                                ElevatedButton(
                                                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.albaikRichRed),
                                                  onPressed: () => Navigator.pop(deleteCtx, true),
                                                  child: const Text('حذف نهائي'),
                                                ),
                                              ],
                                            ),
                                          );
                                          if (confirmDelete == true) {
                                            provider.deleteInventoryPart(existingPart!);
                                            if (ctx.mounted) Navigator.pop(ctx);
                                            if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم حذف القطعة من المخزون')));
                                          }
                                        } else if (currentQty <= 1 && !isEditMode) {
                                          if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('لا يمكن أن تكون الكمية أقل من 1 عند الإضافة')));
                                        }
                                      },
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(Icons.add_circle_outline, color: Colors.green.shade700),
                                      onPressed: () {
                                        _unfocusAll();
                                        int currentQty = int.tryParse(_qtyCtrl.text) ?? 0;
                                        setSheetState(() => _qtyCtrl.text = (currentQty + 1).toString());
                                      },
                                    ),
                                  ),
                                  validator: (val) => val!.isEmpty ? '*' : null,
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 32),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate() && _selectedBrand != null && _selectedModel != null && _selectedPartType != null) {
                                final partToSave = isEditMode ? existingPart! : LocalPart();
                                
                                if (!isEditMode) {
                                  partToSave.partId = DateTime.now().millisecondsSinceEpoch.toString();
                                }

                                partToSave.partName = _partNameCtrl.text.trim();
                                partToSave.deviceBrand = _selectedBrand!.name;
                                partToSave.deviceModel = _selectedModel!;
                                partToSave.partType = _selectedPartType!;
                                partToSave.costPrice = double.tryParse(_costCtrl.text) ?? 0.0;
                                partToSave.quantity = int.tryParse(_qtyCtrl.text) ?? 1;

                                if (isEditMode) {
                                  provider.updateInventoryPart(partToSave);
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تحديث القطعة بنجاح')));
                                } else {
                                  provider.addInventoryPart(partToSave);
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تمت إضافة القطعة بنجاح')));
                                }
                                
                                Navigator.pop(ctx);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('يرجى تعبئة جميع الحقول المطلوبة')));
                              }
                            },
                            child: Text(isEditMode ? 'تحديث البيانات' : 'حفظ القطعة الجديدة'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<InventoryProvider>(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'إدارة المخزون المحلي'),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: AppTheme.albaikDeepNavy.withValues(alpha: 0.02),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${provider.inventory.length} قطعة متوفرة', style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.albaikDeepNavy)),
                TextButton.icon(
                  onPressed: () async {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('جاري المزامنة مع السحابة...')));
                    String result = await provider.syncInventoryWithCloud();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
                    }
                  },
                  icon: const Icon(Icons.cloud_sync, color: AppTheme.albaikRichRed),
                  label: const Text('مزامنة الآن', style: TextStyle(color: AppTheme.albaikRichRed)),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: provider.inventory.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inventory_2_outlined, size: 80, color: AppTheme.albaikDeepNavy.withValues(alpha: 0.1)),
                        const SizedBox(height: 16),
                        const Text('المخزون فارغ حالياً', style: TextStyle(color: AppTheme.albaikDeepNavy, fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: provider.inventory.length,
                    itemBuilder: (ctx, i) {
                      final part = provider.inventory[i];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.shade200)),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => _showPartFormDialog(context, provider, existingPart: part), 
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundColor: part.quantity <= 2 ? AppTheme.albaikRichRed.withValues(alpha: 0.1) : Colors.green.shade50,
                              child: Text(
                                part.quantity.toString(), 
                                style: TextStyle(fontSize: 18, color: part.quantity <= 2 ? AppTheme.albaikRichRed : Colors.green.shade700, fontWeight: FontWeight.bold)
                              ),
                            ),
                            title: Text(part.partName, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.albaikDeepNavy, fontSize: 16)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.smartphone, size: 14, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text('${part.deviceBrand} - ${part.deviceModel}', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('التصنيف: ${part.partType}', style: const TextStyle(color: AppTheme.albaikRichRed, fontSize: 12, fontWeight: FontWeight.bold)),
                                    Text('التكلفة: ${part.costPrice} د.أ', style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            ),
                            trailing: const Icon(Icons.edit_outlined, color: Colors.grey, size: 20),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: AnimatedFab(
        onPressed: () => _showPartFormDialog(context, provider), 
      ),
    );
  }
}

class AnimatedFab extends StatefulWidget {
  final VoidCallback onPressed;
  const AnimatedFab({Key? key, required this.onPressed}) : super(key: key);

  @override
  State<AnimatedFab> createState() => _AnimatedFabState();
}

class _AnimatedFabState extends State<AnimatedFab> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.85 : 1.0,
        duration: AppAnimations.fast,
        curve: AppAnimations.bouncy,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppTheme.albaikDeepNavy,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: AppTheme.albaikDeepNavy.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 30),
        ),
      ),
    );
  }
}