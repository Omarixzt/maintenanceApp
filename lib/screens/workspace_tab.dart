import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/app_models.dart';
import '../theme/custom_app_bar.dart';
import '../theme/app_theme.dart';

class WorkspaceTab extends StatelessWidget {
  const WorkspaceTab({Key? key}) : super(key: key);

  void _showTicketDetails(BuildContext context, AppProvider provider, MaintenanceTicket ticket) {
    LocalPart? selectedPart; 

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20, right: 20, top: 20
              ),
              height: MediaQuery.of(context).size.height * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('تفاصيل الصيانة', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.albaikDeepNavy), textAlign: TextAlign.center),
                  const Divider(height: 32),
                  
                  Text('العميل: ${ticket.customerName} (${ticket.phoneNumber})', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text('الجهاز: ${ticket.deviceType} ${ticket.deviceModel}', style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('العطل: ${ticket.faultDescription}', style: const TextStyle(fontSize: 16, color: AppTheme.albaikRichRed)),
                  const SizedBox(height: 8),
                  Text('التكلفة المتوقعة: ${ticket.expectedCost}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  
                  const Divider(height: 32),
                  const Text('إدارة القطع المستخدمة (تؤثر على صافي الربح)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.albaikDeepNavy)),
                  const SizedBox(height: 12),
                  
                  DropdownButtonFormField<LocalPart>(
                    decoration: const InputDecoration(labelText: 'اختر القطعة لخصمها من المخزون'),
                    value: selectedPart,
                    items: provider.inventory.map((part) {
                      return DropdownMenuItem<LocalPart>(
                        value: part,
                        child: Text('${part.partName} (المتوفر: ${part.quantity})'),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setModalState(() => selectedPart = val);
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  ElevatedButton.icon(
                    icon: const Icon(Icons.inventory_2),
                    label: const Text('خصم القطعة وحساب الربح'),
                    onPressed: selectedPart == null || selectedPart!.quantity <= 0 ? null : () async {
                      // هنا نستخدم الدالة التي تخصم القطعة وتحسب صافي ربح هذه التذكرة
                      bool success = await provider.usePartForTicket(ticket, selectedPart!);
                      Navigator.pop(ctx);
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم خصم القطعة وحساب الربح بنجاح')));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('فشلت العملية، تأكد من توفر القطعة')));
                      }
                    },
                  ),
                ],
              ),
            );
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final activeTickets = provider.tickets.where((t) => t.status != 'Delivered').toList();

    return Scaffold(
      appBar: const CustomAppBar(title: 'ورشة الصيانة'),
      body: activeTickets.isEmpty 
        ? const Center(child: Text('لا توجد أجهزة في الورشة', style: TextStyle(color: AppTheme.albaikDeepNavy, fontSize: 16, fontWeight: FontWeight.bold)))
        : ListView.builder(
            padding: const EdgeInsets.all(12.0),
            itemCount: activeTickets.length,
            itemBuilder: (ctx, i) {
              final ticket = activeTickets[i];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.shade200)),
                elevation: 0,
                color: AppTheme.albaikPureWhite,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text('${ticket.deviceModel} - ${ticket.customerName}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.albaikDeepNavy, fontSize: 16)),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text('العطل: ${ticket.faultDescription}\nالحالة: ${ticket.status}', style: TextStyle(color: AppTheme.albaikDeepNavy.withOpacity(0.7))),
                  ),
                  isThreeLine: true,
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppTheme.albaikDeepNavy.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButton<String>(
                      value: ticket.status,
                      underline: const SizedBox(),
                      icon: const Icon(Icons.arrow_drop_down, color: AppTheme.albaikDeepNavy),
                      items: ['Waiting', 'In Progress', 'Waiting for Parts', 'Ready', 'Delivered']
                          .map((s) => DropdownMenuItem(value: s, child: Text(s, style: TextStyle(
                            color: s == 'Delivered' ? Colors.green.shade700 : AppTheme.albaikDeepNavy,
                            fontWeight: s == 'Delivered' ? FontWeight.bold : FontWeight.w600
                          )))).toList(),
                      onChanged: (newStatus) {
                        if (newStatus != null) {
                          provider.updateTicketStatus(ticket, newStatus);
                          if (newStatus == 'Delivered') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('تم التسليم ومزامنة البيانات مالياً مع POS'))
                            );
                          }
                        }
                      },
                    ),
                  ),
                  onTap: () => _showTicketDetails(context, provider, ticket),
                ),
              );
            },
          ),
    );
  }
}