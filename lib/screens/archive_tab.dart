import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import '../models/app_models.dart';
import '../services/isar_service.dart';
import '../theme/custom_app_bar.dart';
import '../theme/app_theme.dart';

class ArchiveTab extends StatefulWidget {
  const ArchiveTab({Key? key}) : super(key: key);

  @override
  State<ArchiveTab> createState() => _ArchiveTabState();
}

class _ArchiveTabState extends State<ArchiveTab> {
  String _searchQuery = '';
  DateTime? _selectedFilterDate; 
  List<MaintenanceTicket> _archivedTickets = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadArchivedTickets();
  }

  Future<void> _loadArchivedTickets() async {
    final isar = await IsarService.db;
    final tickets = await isar.maintenanceTickets
        .filter()
        .isArchivedEqualTo(true)
        .sortByReceivedDateDesc()
        .findAll();
        
    setState(() {
      _archivedTickets = tickets;
      _isLoading = false;
    });
  }

  void _unfocusAll() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void _viewFullImage(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(10),
        child: Stack(
          alignment: Alignment.center,
          children: [
            InteractiveViewer(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.file(File(imagePath), fit: BoxFit.contain),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: CircleAvatar(
                backgroundColor: Colors.black54,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showArchivedDetails(MaintenanceTicket ticket) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        String formattedDate = ticket.receivedDate;
        try {
          formattedDate = DateFormat('yyyy-MM-dd | hh:mm a').format(DateTime.parse(ticket.receivedDate));
        } catch (_) {}

        return Container(
          decoration: const BoxDecoration(
            color: AppTheme.albaikPureWhite,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: AppTheme.albaikDeepNavy,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                height: 12,
              ),
              const SizedBox(height: 16),
              const Text('سجل الجهاز المؤرشف', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.albaikDeepNavy), textAlign: TextAlign.center),
              const Divider(),
              
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildImageSection(ticket.imagePath, 'عند الاستلام'),
                          _buildImageSection(ticket.imagePathAfter, 'عند التسليم'),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildInfoRow(Icons.person, 'العميل', ticket.customerName),
                      _buildInfoRow(Icons.phone, 'رقم الهاتف', ticket.phoneNumber),
                      _buildInfoRow(Icons.smartphone, 'الجهاز', '${ticket.deviceType} ${ticket.deviceModel}'),
                      _buildInfoRow(Icons.build, 'العطل', ticket.faultDescription),
                      _buildInfoRow(Icons.calendar_today, 'التاريخ', formattedDate),
                      if (ticket.expectedDeliveryDate != null)
                        _buildInfoRow(Icons.event_available, 'موعد التسليم', DateFormat('yyyy-MM-dd').format(DateTime.parse(ticket.expectedDeliveryDate!))),
                      const Divider(height: 32),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.green.shade200)
                        ),
                        child: Column(
                          children: [
                            _buildFinanceRow('التكلفة النهائية', '${ticket.finalCost} د.أ', Colors.black),
                            const SizedBox(height: 8),
                            _buildFinanceRow('صافي الربح', '${ticket.netProfit} د.أ', Colors.green.shade700),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImageSection(String? path, String label) {
    bool hasImage = path != null && File(path).existsSync();
    
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: hasImage ? () => _viewFullImage(context, path) : null,
          child: Container(
            width: 100, height: 100,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: hasImage ? AppTheme.albaikRichRed : Colors.grey.shade300, width: hasImage ? 2 : 1)
            ),
            child: hasImage
              ? ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.file(File(path), fit: BoxFit.cover))
              : const Icon(Icons.image_not_supported, color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.albaikDeepNavy.withOpacity(0.6), size: 20),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFinanceRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: color)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final results = _archivedTickets.where((t) {
      // 1. التصفية حسب نص البحث
      bool matchesSearch = true;
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        matchesSearch = t.phoneNumber.contains(query) || 
               t.deviceModel.toLowerCase().contains(query) || 
               t.customerName.toLowerCase().contains(query) ||
               t.imei.contains(query);
      }

      // 2. التصفية حسب التاريخ المحدد (إن وجد)
      bool matchesDate = true;
      if (_selectedFilterDate != null) {
        String tDate = "";
        try {
          tDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(t.receivedDate));
        } catch (_) { 
          tDate = t.receivedDate; 
        }
        String filterDateStr = DateFormat('yyyy-MM-dd').format(_selectedFilterDate!);
        matchesDate = (tDate == filterDateStr);
      }

      return matchesSearch && matchesDate;
    }).toList();

    // تجميع التذاكر حسب التاريخ
    Map<String, List<MaintenanceTicket>> groupedTickets = {};
    for (var t in results) {
      String dateKey = "";
      try {
        dateKey = DateFormat('yyyy-MM-dd').format(DateTime.parse(t.receivedDate));
      } catch (_) {
        dateKey = t.receivedDate;
      }
      if (!groupedTickets.containsKey(dateKey)) {
        groupedTickets[dateKey] = [];
      }
      groupedTickets[dateKey]!.add(t);
    }

    // ترتيب التواريخ تنازلياً (من الأحدث إلى الأقدم)
    List<String> sortedDates = groupedTickets.keys.toList();
    sortedDates.sort((a, b) => b.compareTo(a));

    return Scaffold(
      appBar: const CustomAppBar(title: 'السجل والكفالات'),
      body: GestureDetector(
        onTap: _unfocusAll,
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // شريط البحث يأخذ المساحة الأكبر ويظهر أولاً
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'ابحث بالاسم، الموديل...',
                          prefixIcon: const Icon(Icons.search, color: AppTheme.albaikDeepNavy),
                          contentPadding: const EdgeInsets.symmetric(vertical: 0),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                          suffixIcon: _searchQuery.isNotEmpty 
                              ? IconButton(icon: const Icon(Icons.clear, size: 20), onPressed: () => setState(() => _searchQuery = '')) 
                              : null,
                        ),
                        onChanged: (val) => setState(() => _searchQuery = val),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // زر التقويم أصبح على الجهة الأخرى
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 52, 
                    width: 52,
                    decoration: BoxDecoration(
                      color: _selectedFilterDate != null ? AppTheme.albaikRichRed : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: _selectedFilterDate != null ? [
                        BoxShadow(color: AppTheme.albaikRichRed.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))
                      ] : [],
                    ),
                    child: IconButton(
                      icon: Icon(
                        _selectedFilterDate != null ? Icons.event_busy : Icons.calendar_month,
                        color: _selectedFilterDate != null ? Colors.white : AppTheme.albaikDeepNavy,
                      ),
                      tooltip: _selectedFilterDate != null ? 'إلغاء فلترة التاريخ' : 'البحث حسب التاريخ',
                      onPressed: () async {
                        _unfocusAll();
                        if (_selectedFilterDate != null) {
                          setState(() => _selectedFilterDate = null);
                          return;
                        }
                        
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: AppTheme.albaikRichRed, 
                                  onPrimary: Colors.white,
                                  onSurface: AppTheme.albaikDeepNavy,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          setState(() => _selectedFilterDate = picked);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppTheme.albaikRichRed))
                  : sortedDates.isEmpty
                      ? Center(child: Text((_searchQuery.isEmpty && _selectedFilterDate == null) ? 'الأرشيف فارغ حالياً' : 'لا توجد نتائج مطابقة', style: TextStyle(color: AppTheme.albaikDeepNavy.withOpacity(0.5))))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          itemCount: sortedDates.length,
                          itemBuilder: (ctx, i) {
                            String currentDate = sortedDates[i];
                            List<MaintenanceTicket> dailyTickets = groupedTickets[currentDate]!;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: AppTheme.albaikDeepNavy.withOpacity(0.05),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          currentDate,
                                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.albaikDeepNavy),
                                        ),
                                      ),
                                      const Expanded(child: Divider(indent: 12, color: Colors.black12, thickness: 1)),
                                    ],
                                  ),
                                ),
                                ...dailyTickets.map((t) {
                                  String dateFormatted = "";
                                  try {
                                    dateFormatted = DateFormat('yyyy-MM-dd').format(DateTime.parse(t.receivedDate));
                                  } catch (_) { dateFormatted = t.receivedDate; }
                                  
                                  return Card(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      side: BorderSide(color: Colors.grey.shade200)
                                    ),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(15),
                                      onTap: () => _showArchivedDetails(t),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(t.customerName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: AppTheme.albaikDeepNavy)),
                                                      const SizedBox(height: 4),
                                                      Row(
                                                        children: [
                                                          Icon(Icons.phone, size: 14, color: AppTheme.albaikDeepNavy.withOpacity(0.6)),
                                                          const SizedBox(width: 4),
                                                          Text(t.phoneNumber, style: TextStyle(fontSize: 13, color: AppTheme.albaikDeepNavy.withOpacity(0.8), fontWeight: FontWeight.w600)),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Text('${t.finalCost > 0 ? t.finalCost : t.expectedCost} د.أ', style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.albaikRichRed)),
                                              ],
                                            ),
                                            const SizedBox(height: 12),
                                            Row(
                                              children: [
                                                const Icon(Icons.smartphone, size: 14, color: AppTheme.albaikRichRed),
                                                const SizedBox(width: 6),
                                                Text('${t.deviceType} ${t.deviceModel}', style: const TextStyle(fontWeight: FontWeight.w600)),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text('تاريخ الاستلام: $dateFormatted', style: TextStyle(fontSize: 12, color: AppTheme.albaikDeepNavy.withOpacity(0.5))),
                                                if (t.expectedDeliveryDate != null)
                                                  Text('التسليم: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(t.expectedDeliveryDate!))}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.albaikDeepNavy.withOpacity(0.7))),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                  decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(5)),
                                                  child: Text(t.status == 'Delivered' ? 'تم التسليم' : t.status, style: TextStyle(fontSize: 10, color: Colors.green.shade700, fontWeight: FontWeight.bold)),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ],
                            );
                          },
                        ),
            )
          ],
        ),
      ),
    );
  }
}