import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/ticket_provider.dart';
import '../providers/settings_provider.dart';
import '../models/app_models.dart';
import '../theme/custom_app_bar.dart';
import '../theme/app_theme.dart';
import '../services/printer_service.dart';

class WorkspaceTab extends StatefulWidget {
  const WorkspaceTab({Key? key}) : super(key: key);

  @override
  State<WorkspaceTab> createState() => _WorkspaceTabState();
}

class _WorkspaceTabState extends State<WorkspaceTab> {
  String _searchQuery = ''; 

  static final Map<String, Map<String, dynamic>> _statusConfig = {
    'Waiting': {'label': 'قيد الانتظار', 'color': Colors.orange.shade700},
    'In Progress': {'label': 'جاري العمل', 'color': Colors.blue.shade700},
    'Waiting for Parts': {'label': 'بانتظار القطع', 'color': Colors.deepPurple.shade600},
    'Ready': {'label': 'جاهز للتسليم', 'color': Colors.green.shade600},
    'Delivered': {'label': 'تم التسليم', 'color': Colors.teal.shade800},
  };

  void _unfocusAll() => FocusManager.instance.primaryFocus?.unfocus();

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

  // النافذة المنبثقة الجديدة لخيارات الطباعة والمشاركة
  void _showPrintOptionsDialog(BuildContext context, MaintenanceTicket ticket) {
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.print, color: AppTheme.albaikDeepNavy),
            SizedBox(width: 10),
            Text('الطباعة والمشاركة', style: TextStyle(color: AppTheme.albaikDeepNavy, fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // قسم وصل الزبون
            const Text('وصل الزبون', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.albaikDeepNavy, fontSize: 14)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx); // إغلاق النافذة
                      PrinterService.printWithFallbackDialog(
                        context: context,
                        ticket: ticket,
                        macAddress: settingsProvider.printerMac,
                        isCustomerCopy: true,
                      );
                    },
                    icon: const Icon(Icons.print, size: 18),
                    label: const Text('طباعة'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.albaikDeepNavy,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx); // إغلاق النافذة
                      PrinterService.generateAndShareReceiptDirectly(
                        context: context,
                        ticket: ticket,
                        isCustomerCopy: true,
                      );
                    },
                    icon: const Icon(Icons.share, size: 18),
                    label: const Text('مشاركة'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.albaikDeepNavy,
                      side: const BorderSide(color: AppTheme.albaikDeepNavy, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
            
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(height: 1, color: Colors.black12),
            ),
            
            // قسم ملصق المحل
            const Text('ملصق المحل', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.albaikRichRed, fontSize: 14)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      PrinterService.printWithFallbackDialog(
                        context: context,
                        ticket: ticket,
                        macAddress: settingsProvider.printerMac,
                        isCustomerCopy: false,
                      );
                    },
                    icon: const Icon(Icons.print, size: 18),
                    label: const Text('طباعة'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.albaikRichRed,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      PrinterService.generateAndShareReceiptDirectly(
                        context: context,
                        ticket: ticket,
                        isCustomerCopy: false,
                      );
                    },
                    icon: const Icon(Icons.share, size: 18),
                    label: const Text('مشاركة'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.albaikRichRed,
                      side: const BorderSide(color: AppTheme.albaikRichRed, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _promptForArchiveDetails(BuildContext context, TicketProvider provider, MaintenanceTicket ticket, String newStatus) async {
    final finalCostCtrl = TextEditingController(text: ticket.expectedCost.toString());
    final partsCostCtrl = TextEditingController(text: '0');
    final formKey = GlobalKey<FormState>();

    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.monetization_on, color: Colors.green, size: 28),
            SizedBox(width: 10),
            Text('تأكيد الحساب والأرشفة', style: TextStyle(color: AppTheme.albaikDeepNavy, fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('يرجى إدخال الحساب النهائي لحساب الأرباح قبل النقل للأرشيف:', style: TextStyle(fontSize: 13, color: Colors.grey)),
              const SizedBox(height: 16),
              TextFormField(
                controller: finalCostCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'المبلغ النهائي من العميل', prefixIcon: Icon(Icons.attach_money)),
                validator: (v) => v!.isEmpty ? 'مطلوب' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: partsCostCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'تكلفة القطع (إن وجدت)', prefixIcon: Icon(Icons.money_off)),
                validator: (v) => v!.isEmpty ? 'مطلوب' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('إلغاء', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(ctx, true);
              }
            },
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      double finalC = double.tryParse(finalCostCtrl.text) ?? 0.0;
      double partsC = double.tryParse(partsCostCtrl.text) ?? 0.0;
      
      ticket.finalCost = finalC;
      ticket.netProfit = finalC - partsC;
      
      provider.updateTicketStatus(ticket, newStatus, archive: true);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم أرشفة الجهاز وحفظ الأرباح بنجاح')));
      }
    }
  }

  void _showTicketDetails(BuildContext context, TicketProvider provider, MaintenanceTicket ticket) {
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
          height: MediaQuery.of(context).size.height * 0.85,
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
              Container(color: AppTheme.albaikRichRed, height: 6),
              const SizedBox(height: 16),
              const Text(
                'تفاصيل الجهاز',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.albaikDeepNavy),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildImagePreview(context, ticket.imagePath, 'قبل الإصلاح'),
                  _buildImagePreview(context, ticket.imagePathAfter, 'بعد الإصلاح'),
                ],
              ),

              const SizedBox(height: 16),
              const Divider(height: 1),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Column(
                    children: [
                      _buildDetailRow(Icons.person, 'العميل', ticket.customerName),
                      _buildDetailRow(Icons.phone, 'رقم الهاتف', ticket.phoneNumber),
                      _buildDetailRow(Icons.smartphone, 'الجهاز', '${ticket.deviceType} - ${ticket.deviceModel}'),
                      if (ticket.imei.isNotEmpty) _buildDetailRow(Icons.qr_code, 'IMEI', ticket.imei),
                      _buildDetailRow(Icons.build_circle, 'العطل', ticket.faultDescription, valueColor: AppTheme.albaikRichRed),
                      _buildDetailRow(Icons.attach_money, 'التكلفة المتوقعة', '${ticket.expectedCost}', isBold: true),
                      if (ticket.finalCost > 0)
                        _buildDetailRow(Icons.monetization_on, 'التكلفة النهائية', '${ticket.finalCost}', isBold: true, valueColor: Colors.green.shade700),
                      _buildDetailRow(Icons.calendar_today, 'تاريخ الاستلام', formattedDate),
                      if (ticket.expectedDeliveryDate != null)
                        _buildDetailRow(Icons.event_available, 'موعد التسليم المتوقع', DateFormat('yyyy-MM-dd').format(DateTime.parse(ticket.expectedDeliveryDate!)), valueColor: Colors.orange.shade800),
                    ],
                  ),
                ),
              ),

              // الأزرار الجديدة داخل النافذة
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.albaikDeepNavy,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        icon: const Icon(Icons.print_outlined),
                        label: const Text('طباعة / مشاركة الوصل', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        onPressed: () {
                          // فتح نافذة الطباعة دون إغلاق تفاصيل الجهاز
                          _showPrintOptionsDialog(context, ticket);
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.albaikRichRed,
                          side: const BorderSide(color: AppTheme.albaikRichRed, width: 2),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        icon: const Icon(Icons.archive),
                        label: const Text('نقل الجهاز إلى الأرشيف', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        onPressed: () {
                          Navigator.pop(ctx);
                          _promptForArchiveDetails(context, provider, ticket, ticket.status);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImagePreview(BuildContext context, String? path, String label) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.albaikDeepNavy)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: path != null ? () => _viewFullImage(context, path) : null,
          child: Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: path != null ? AppTheme.albaikRichRed : Colors.grey.shade300, width: 2),
              boxShadow: [
                if (path != null)
                  BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8, offset: const Offset(0, 4)),
              ],
            ),
            child: path != null
                ? ClipRRect(borderRadius: BorderRadius.circular(18), child: Image.file(File(path), fit: BoxFit.cover))
                : const Icon(Icons.image_not_supported, color: Colors.grey, size: 40),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, {Color? valueColor, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.albaikDeepNavy.withValues(alpha: 0.6), size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: AppTheme.albaikDeepNavy.withValues(alpha: 0.6), fontSize: 12)),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: valueColor ?? AppTheme.albaikDeepNavy,
                    fontSize: 16,
                    fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleStatusChange(BuildContext context, TicketProvider provider, MaintenanceTicket ticket, String newStatus) async {
    if (newStatus == ticket.status) return;

    if (newStatus == 'Ready') {
      final bool? confirmPhoto = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('توثيق الجاهزية'),
          content: const Text('هل ترغب في التقاط صورة للجهاز بعد الإصلاح لتوثيق الحالة النهائية؟'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('تخطي')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.albaikDeepNavy),
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('فتح الكاميرا'),
            ),
          ],
        ),
      );

      if (confirmPhoto == true) {
        final XFile? photo = await ImagePicker().pickImage(source: ImageSource.camera);
        if (photo != null) {
          ticket.imagePathAfter = photo.path;
        }
      }
      provider.updateTicketStatus(ticket, newStatus, archive: false);
    } 
    else if (newStatus == 'Delivered') {
      await _promptForArchiveDetails(context, provider, ticket, newStatus);
    } 
    else {
      provider.updateTicketStatus(ticket, newStatus, archive: false);
    }
  }

  Widget _buildStatusBadge(BuildContext context, MaintenanceTicket ticket, Map<String, dynamic> statusInfo, TicketProvider provider) {
    return PopupMenuButton<String>(
      onSelected: (val) => _handleStatusChange(context, provider, ticket, val),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      itemBuilder: (ctx) => _statusConfig.keys.map((k) => PopupMenuItem(
        value: k, 
        child: Row(
          children: [
            Icon(Icons.circle, color: _statusConfig[k]!['color'], size: 12),
            const SizedBox(width: 10),
            Text(_statusConfig[k]!['label'], style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        )
      )).toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: (statusInfo['color'] as Color).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: (statusInfo['color'] as Color).withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Text(
              statusInfo['label'],
              style: TextStyle(color: statusInfo['color'], fontWeight: FontWeight.bold, fontSize: 12),
            ),
            Icon(Icons.arrow_drop_down, color: statusInfo['color'], size: 18),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TicketProvider>(context);
    
    final filteredTickets = provider.tickets.where((t) {
      final query = _searchQuery.toLowerCase();
      return t.customerName.toLowerCase().contains(query) ||
             t.phoneNumber.contains(query) ||
             t.deviceType.toLowerCase().contains(query) ||
             t.deviceModel.toLowerCase().contains(query) ||
             t.expectedCost.toString().contains(query);
    }).toList();

    return Scaffold(
      appBar: const CustomAppBar(title: 'ورشة الصيانة'),
      body: GestureDetector(
        onTap: _unfocusAll,
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'ابحث بالاسم، الرقم، الجهاز، أو التكلفة...',
                  prefixIcon: const Icon(Icons.search, color: AppTheme.albaikDeepNavy),
                  suffixIcon: _searchQuery.isNotEmpty 
                      ? IconButton(icon: const Icon(Icons.clear), onPressed: () => setState(() => _searchQuery = ''))
                      : null,
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                ),
                onChanged: (val) => setState(() => _searchQuery = val),
              ),
            ),

            Expanded(
              child: filteredTickets.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off_outlined, size: 80, color: AppTheme.albaikDeepNavy.withValues(alpha: 0.1)),
                          const SizedBox(height: 16),
                          Text(
                            _searchQuery.isEmpty ? 'الورشة فارغة حالياً' : 'لا توجد نتائج مطابقة لبحثك',
                            style: TextStyle(color: AppTheme.albaikDeepNavy.withValues(alpha: 0.5), fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: filteredTickets.length,
                      itemBuilder: (ctx, i) {
                        final ticket = filteredTickets[i];
                        final statusInfo = _statusConfig[ticket.status] ?? _statusConfig['Waiting']!;

                        return Card(
                          elevation: 0,
                          margin: const EdgeInsets.only(bottom: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: AppTheme.albaikDeepNavy.withValues(alpha: 0.1), width: 1.5),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () => _showTicketDetails(context, provider, ticket),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        ticket.customerName,
                                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.albaikDeepNavy, fontSize: 18),
                                      ),
                                      _buildStatusBadge(context, ticket, statusInfo, provider),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  
                                  Row(
                                    children: [
                                      const Icon(Icons.smartphone, size: 16, color: AppTheme.albaikRichRed),
                                      const SizedBox(width: 8),
                                      Text(
                                        '${ticket.deviceType} ${ticket.deviceModel}',
                                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Icon(Icons.build_circle_outlined, size: 14, color: AppTheme.albaikDeepNavy.withValues(alpha: 0.5)),
                                            const SizedBox(width: 6),
                                            Flexible(
                                              child: Text(
                                                ticket.faultDescription,
                                                style: TextStyle(color: AppTheme.albaikDeepNavy.withValues(alpha: 0.7), fontSize: 13),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade50,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: Colors.green.shade100),
                                        ),
                                        child: Text(
                                          '${ticket.expectedCost} د.أ',
                                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade700, fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                  
                                  if (ticket.expectedDeliveryDate != null) ...[
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Icon(Icons.access_time_filled, size: 14, color: Colors.orange.shade700),
                                        const SizedBox(width: 6),
                                        Text(
                                          'التسليم المتوقع: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(ticket.expectedDeliveryDate!))}',
                                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.orange.shade800),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
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