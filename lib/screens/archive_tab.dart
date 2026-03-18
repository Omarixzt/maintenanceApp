import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_provider.dart';
import '../theme/custom_app_bar.dart';
import '../theme/app_theme.dart';

class ArchiveTab extends StatefulWidget {
  const ArchiveTab({Key? key}) : super(key: key);

  @override
  State<ArchiveTab> createState() => _ArchiveTabState();
}

class _ArchiveTabState extends State<ArchiveTab> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final results = provider.tickets.where((t) {
      if (_searchQuery.isEmpty) return false;
      return t.phoneNumber.contains(_searchQuery) || 
             t.imei.contains(_searchQuery) || 
             t.customerName.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: const CustomAppBar(title: 'السجل والكفالات'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'ابحث برقم الهاتف، IMEI، أو اسم العميل...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: results.length,
              itemBuilder: (ctx, i) {
                final t = results[i];
                final dateFormatted = DateFormat('yyyy-MM-dd').format(DateTime.parse(t.receivedDate));
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.shade200)),
                  elevation: 0,
                  child: ListTile(
                    title: Text(t.customerName, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.albaikDeepNavy)),
                    subtitle: Text('${t.deviceModel} | تاريخ الاستلام: $dateFormatted', style: TextStyle(color: AppTheme.albaikDeepNavy.withOpacity(0.7))),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.albaikDeepNavy.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(t.status, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.albaikDeepNavy)),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}