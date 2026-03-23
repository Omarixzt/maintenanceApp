import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final _shopNameCtrl = TextEditingController();
  final _customCodeCtrl = TextEditingController();
  
  int _selectedMonths = 1; // الافتراضي شهر واحد
  DateTime? _customExpiryDate;
  bool _isLoading = false;

  final List<Map<String, dynamic>> _durations = [
    {'label': 'شهر واحد', 'months': 1},
    {'label': '3 أشهر', 'months': 3},
    {'label': '6 أشهر', 'months': 6},
    {'label': 'سنة كاملة', 'months': 12},
    {'label': 'تاريخ مخصص', 'months': 0}, // 0 يعني تاريخ مخصص
  ];

  void _unfocusAll() => FocusManager.instance.primaryFocus?.unfocus();

  // توليد كود عشوائي بصيغة (AB-123456)
  String _generateRandomCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final random = Random();
    String letters = String.fromCharCodes(Iterable.generate(2, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
    String numbers = (random.nextInt(900000) + 100000).toString();
    return '$letters-$numbers';
  }

  Future<void> _pickCustomDate() async {
    _unfocusAll();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)), // 10 سنوات للأمام
    );
    if (picked != null) {
      setState(() {
        _customExpiryDate = picked;
      });
    }
  }

  Future<void> _generateSubscription() async {
    _unfocusAll();
    final shopName = _shopNameCtrl.text.trim();
    
    if (shopName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('يرجى إدخال اسم المحل'), backgroundColor: Colors.red));
      return;
    }

    if (_selectedMonths == 0 && _customExpiryDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('يرجى تحديد تاريخ الانتهاء المخصص'), backgroundColor: Colors.red));
      return;
    }

    setState(() => _isLoading = true);

    try {
      // تحديد الكود (إما المخصص أو توليد جديد)
      String activationCode = _customCodeCtrl.text.trim().toUpperCase();
      if (activationCode.isEmpty) {
        activationCode = _generateRandomCode();
      }

      // حساب تاريخ الانتهاء
      DateTime expiryDate;
      if (_selectedMonths > 0) {
        expiryDate = DateTime.now().add(Duration(days: _selectedMonths * 30));
      } else {
        expiryDate = _customExpiryDate!;
      }

      // حفظ في فايربيس
      await FirebaseFirestore.instance.collection('subscriptions').doc(activationCode).set({
        'shopName': shopName,
        'isActive': true,
        'expiryDate': Timestamp.fromDate(expiryDate),
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      // إظهار رسالة النجاح مع الكود
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          title: const Icon(Icons.check_circle, color: Colors.green, size: 50),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('تم توليد الاشتراك بنجاح!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 16),
              const Text('أرسل هذا الكود للعميل:', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 8),
              SelectableText(
                activationCode,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 2, color: Colors.blueAccent),
              ),
              const SizedBox(height: 16),
              Text('ينتهي في: ${expiryDate.toString().substring(0, 10)}'),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                setState(() {
                  _shopNameCtrl.clear();
                  _customCodeCtrl.clear();
                  _customExpiryDate = null;
                  _selectedMonths = 1;
                });
              },
              child: const Text('تم'),
            )
          ],
        ),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('حدث خطأ: $e'), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة الاشتراكات والمحلات', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1E293B),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: _unfocusAll,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('بيانات المحل', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextField(
                controller: _shopNameCtrl,
                decoration: InputDecoration(
                  labelText: 'اسم المحل (مثل: صيانة البيك)',
                  prefixIcon: const Icon(Icons.store),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _customCodeCtrl,
                decoration: InputDecoration(
                  labelText: 'كود مخصص (اختياري)',
                  hintText: 'اتركه فارغاً لتوليد كود عشوائي',
                  prefixIcon: const Icon(Icons.vpn_key),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              
              const SizedBox(height: 32),
              const Text('مدة الاشتراك', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _durations.map((duration) {
                  final isSelected = _selectedMonths == duration['months'];
                  return ChoiceChip(
                    label: Text(duration['label']),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedMonths = duration['months'] as int);
                        if (_selectedMonths == 0) _pickCustomDate();
                      }
                    },
                    selectedColor: const Color(0xFF1E293B).withOpacity(0.2),
                    labelStyle: TextStyle(
                      color: isSelected ? const Color(0xFF1E293B) : Colors.black87,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  );
                }).toList(),
              ),

              if (_selectedMonths == 0 && _customExpiryDate != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      const Icon(Icons.event, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text('ينتهي في: ${_customExpiryDate.toString().substring(0, 10)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      const Spacer(),
                      IconButton(icon: const Icon(Icons.edit, size: 20), onPressed: _pickCustomDate),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _generateSubscription,
                  icon: _isLoading 
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.add_moderator),
                  label: const Text('توليد وتفعيل الاشتراك', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E293B),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}