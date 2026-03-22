import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import '../providers/app_provider.dart';
import '../models/app_models.dart';
import '../theme/app_theme.dart';
import '../theme/app_animations.dart';

class IntakePickersHelpers {
  static Widget getBrandLogo(String brandName) {
    String cleanName = brandName.toLowerCase().replaceAll(' ', '');
    return Image.asset(
      'lib/assets/$cleanName.png',
      width: 45,
      height: 45,
      errorBuilder: (context, error, stackTrace) => fallbackLogo(brandName),
    );
  }

  static Widget fallbackLogo(String brandName) {
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
}

class BrandPickerSheet extends StatelessWidget {
  final DeviceBrand? selectedBrand;
  final Function(DeviceBrand) onBrandSelected;
  final VoidCallback onAddNewBrand;

  const BrandPickerSheet({
    Key? key,
    required this.selectedBrand,
    required this.onBrandSelected,
    required this.onAddNewBrand,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.70,
          decoration: const BoxDecoration(
            color: AppTheme.albaikPureWhite,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
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
                  dragStartDelay: const Duration(milliseconds: 500), 
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
                    final isSelected = selectedBrand?.name == brand.name;

                    return InkWell(
                      key: ValueKey(brand.name),
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        onBrandSelected(brand);
                      },
                      child: AnimatedContainer(
                        duration: AppAnimations.fast, 
                        curve: AppAnimations.smoothIn, 
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
                            IntakePickersHelpers.getBrandLogo(brand.name),
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
                  onPressed: onAddNewBrand,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}

class ModelPickerSheet extends StatefulWidget {
  final DeviceBrand? selectedBrand;
  final Function(String) onModelSelected;

  const ModelPickerSheet({
    Key? key,
    required this.selectedBrand,
    required this.onModelSelected,
  }) : super(key: key);

  @override
  State<ModelPickerSheet> createState() => _ModelPickerSheetState();
}

class _ModelPickerSheetState extends State<ModelPickerSheet> {
  late List<String> allModels;
  late List<String> filteredModels;
  final TextEditingController searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    allModels = widget.selectedBrand?.models ?? [];
    filteredModels = List.from(allModels);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.70,
        decoration: const BoxDecoration(
          color: AppTheme.albaikPureWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const Text(
                    'اختر الموديل',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.albaikDeepNavy),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: searchCtrl,
                    decoration: InputDecoration(
                      hintText: 'ابحث عن الموديل...',
                      prefixIcon: const Icon(Icons.search, color: AppTheme.albaikDeepNavy),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppTheme.albaikRichRed, width: 2),
                      ),
                    ),
                    onChanged: (query) {
                      setState(() {
                        filteredModels = allModels
                            .where((model) => model.toLowerCase().contains(query.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: filteredModels.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.device_unknown, size: 48, color: Colors.grey.shade400),
                          const SizedBox(height: 12),
                          const Text('الموديل غير موجود في القائمة', style: TextStyle(color: Colors.grey)),
                          const SizedBox(height: 16),
                          if (searchCtrl.text.isNotEmpty)
                            ElevatedButton.icon(
                              onPressed: () {
                                widget.onModelSelected(searchCtrl.text.trim().toUpperCase());
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('اعتماد هذا الموديل'),
                              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.albaikRichRed),
                            )
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredModels.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(Icons.smartphone, color: AppTheme.albaikDeepNavy),
                          title: Text(
                            filteredModels[index],
                            style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.albaikDeepNavy),
                          ),
                          onTap: () {
                            widget.onModelSelected(filteredModels[index]);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class FaultPickerSheet extends StatelessWidget {
  final List<Map<String, dynamic>> faultTypes;
  final String selectedFaultType;
  final Function(String) onFaultSelected;

  const FaultPickerSheet({
    Key? key,
    required this.faultTypes,
    required this.selectedFaultType,
    required this.onFaultSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.55,
      decoration: const BoxDecoration(
        color: AppTheme.albaikPureWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
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
                itemCount: faultTypes.length,
                itemBuilder: (context, index) {
                  final fault = faultTypes[index];
                  final isSelected = selectedFaultType == fault['name'];
                  final faultColor = fault['color'] as Color;

                  return InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      onFaultSelected(fault['name'] as String);
                    },
                    child: AnimatedContainer(
                      duration: AppAnimations.fast, 
                      curve: AppAnimations.smoothIn, 
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
                            fault['icon'] as IconData,
                            size: 28,
                            color: isSelected ? AppTheme.albaikRichRed : AppTheme.albaikDeepNavy.withOpacity(0.7),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2.0),
                            child: Text(
                              fault['name'] as String,
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
  }
}