import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/app_models.dart';
import '../theme/custom_app_bar.dart';
import '../theme/app_theme.dart';

class InventoryTab extends StatefulWidget {
  const InventoryTab({Key? key}) : super(key: key);

  @override
  State<InventoryTab> createState() => _InventoryTabState();
}

class _InventoryTabState extends State<InventoryTab> {
  // تعريف متغيرات لاختيار الشركة والموديل
  String? selectedBrand;
  String? selectedModel;
  final TextEditingController partTypeCtrl = TextEditingController(); // مثل: شاشة، بطارية، مدخل شحن
  final TextEditingController costCtrl = TextEditingController();
  final TextEditingController qtyCtrl = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void _showAddPartDialog(BuildContext context, AppProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder( // استخدام StatefulBuilder لتحديث القوائم داخل الـ Dialog
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text('إضافة قطعة للمخزون', 
              style: TextStyle(color: AppTheme.albaikDeepNavy, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
            content: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 1. اختيار الشركة
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'اختر الشركة', prefixIcon: Icon(Icons.branding_watermark)),
                      value: selectedBrand,
                      items: provider.brands.map((b) => DropdownMenuItem(value: b.name, child: Text(b.name))).toList(),
                      onChanged: (val) {
                        setDialogState(() {
                          selectedBrand = val;
                          selectedModel = null; // تصفير الموديل عند تغيير الشركة
                        });
                      },
                      validator: (val) => val == null ? 'مطلوب' : null,
                    ),
                    const SizedBox(height: 12),

                    // 2. اختيار الموديل (يظهر بناءً على الشركة المختارة)
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'اختر الموديل', prefixIcon: Icon(Icons.phone_android)),
                      value: selectedModel,
                      items: selectedBrand == null 
                        ? [] 
                        : provider.brands
                            .firstWhere((b) => b.name == selectedBrand)
                            .models
                            .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                            .toList(),
                      onChanged: (val) => setDialogState(() => selectedModel = val),
                      validator: (val) => val == null ? 'مطلوب' : null,
                    ),
                    const SizedBox(height: 12),

                    // 3. نوع القطعة
                    TextFormField(
                      controller: partTypeCtrl,
                      decoration: const InputDecoration(labelText: 'نوع القطعة (شاشة، بطارية...)', prefixIcon: Icon(Icons.settings_suggest)),
                      validator: (val) => val == null || val.isEmpty ? 'مطلوب' : null,
                    ),
                    const SizedBox(height: 12),

                    // 4. التكلفة والكمية
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: costCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'التكلفة', prefixIcon: Icon(Icons.attach_money)),
                            validator: (val) => val == null || val.isEmpty ? 'مطلوب' : null,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: qtyCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'الكمية', prefixIcon: Icon(Icons.numbers)),
                            validator: (val) => val == null || val.isEmpty ? 'مطلوب' : null,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء', style: TextStyle(color: Colors.grey))),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    final newPart = LocalPart()
                      // ندمج الموديل مع نوع القطعة لسهولة البحث لاحقاً
                      ..partName = '$selectedModel - ${partTypeCtrl.text.trim()}'
                      ..costPrice = double.tryParse(costCtrl.text) ?? 0.0
                      ..quantity = int.tryParse(qtyCtrl.text) ?? 0;

                    provider.addInventoryPart(newPart);
                    Navigator.pop(ctx);
                    
                    // تنظيف الحقول بعد الإضافة
                    selectedBrand = null;
                    selectedModel = null;
                    partTypeCtrl.clear();
                    costCtrl.clear();
                    qtyCtrl.clear();
                    
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تمت إضافة القطعة للمخزون')));
                  }
                },
                child: const Text('حفظ'),
              ),
            ],
          );
        }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    
    return Scaffold(
      appBar: const CustomAppBar(title: 'مخزون قطع الغيار'),
      body: provider.inventory.isEmpty 
        ? const Center(child: Text('المخزون فارغ', style: TextStyle(color: AppTheme.albaikDeepNavy, fontSize: 16, fontWeight: FontWeight.bold)))
        : ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: provider.inventory.length,
            itemBuilder: (ctx, i) {
              final part = provider.inventory[i];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.shade200)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: part.quantity <= 2 ? AppTheme.albaikRichRed.withOpacity(0.1) : Colors.green.shade50,
                    child: Text(part.quantity.toString(), 
                      style: TextStyle(color: part.quantity <= 2 ? AppTheme.albaikRichRed : Colors.green.shade700, fontWeight: FontWeight.bold)),
                  ),
                  title: Text(part.partName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('التكلفة: ${part.costPrice} دينار'),
                ),
              );
            },
          ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.albaikDeepNavy,
        onPressed: () => _showAddPartDialog(context, provider),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}