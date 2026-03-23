import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/isar_service.dart';

class AuthProvider extends ChangeNotifier with WidgetsBindingObserver {
  String? currentShopId;
  bool isChecking = true;
  bool isReadOnly = false; 

  AuthProvider() {
    WidgetsBinding.instance.addObserver(this);
    _checkCurrentSession();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // التأكد من أن الكود ليس فارغاً قبل إجراء الفحص الصامت
    if (state == AppLifecycleState.resumed && currentShopId != null && currentShopId!.trim().isNotEmpty) {
      _silentVerify();
    }
  }

  Future<void> _checkCurrentSession() async {
    String? savedCode = await IsarService.getSetting('active_shop_id');
    
    // التعديل الجوهري: منع الاتصال بفايربيس إذا كان الكود فارغاً
    if (savedCode != null && savedCode.trim().isNotEmpty) {
      currentShopId = savedCode;
      await verifySubscription(savedCode);
    } else {
      currentShopId = null;
      isChecking = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> verifySubscription(String code) async {
    isChecking = true;
    notifyListeners();

    try {
      final doc = await FirebaseFirestore.instance.collection('subscriptions').doc(code).get();

      if (doc.exists) {
        final data = doc.data()!;
        bool isActive = data['isActive'] ?? false;
        Timestamp? expiryTimestamp = data['expiryDate'];

        bool isExpired = expiryTimestamp != null && expiryTimestamp.toDate().isBefore(DateTime.now());

        currentShopId = code;
        await IsarService.saveSetting('active_shop_id', code);
        
        if (data.containsKey('shopName')) {
          await IsarService.saveSetting('store_name', data['shopName']);
        }

        if (!isActive || isExpired) {
          isReadOnly = true;
          isChecking = false;
          notifyListeners();
          return {'success': true, 'message': 'تم الدخول في وضع القراءة فقط (الاشتراك منتهي)'};
        }

        isReadOnly = false;
        isChecking = false;
        notifyListeners();
        return {'success': true, 'message': 'تم تسجيل الدخول بنجاح'};
      } else {
        await logout(); 
        return {'success': false, 'message': 'كود التفعيل غير صحيح أو تم حذفه من قبل الإدارة.'};
      }
    } catch (e) {
      if (currentShopId == code) {
        isChecking = false;
        notifyListeners();
        return {'success': true, 'message': 'وضع عدم الاتصال'};
      }
      
      isChecking = false;
      notifyListeners();
      return {'success': false, 'message': 'حدث خطأ في الاتصال.'};
    }
  }

  Future<void> _silentVerify() async {
    try {
      final doc = await FirebaseFirestore.instance.collection('subscriptions').doc(currentShopId).get();
      if (doc.exists) {
        final data = doc.data()!;
        bool isActive = data['isActive'] ?? false;
        Timestamp? expiryTimestamp = data['expiryDate'];

        bool isExpired = expiryTimestamp != null && expiryTimestamp.toDate().isBefore(DateTime.now());

        if (!isActive || isExpired) {
          if (!isReadOnly) {
            isReadOnly = true;
            notifyListeners();
          }
        } else {
          if (isReadOnly) {
            isReadOnly = false;
            notifyListeners();
          }
        }
      } else {
         await logout(); 
      }
    } catch (e) {}
  }

  Future<void> logout() async {
    currentShopId = null;
    isReadOnly = false;
    isChecking = false;
    await IsarService.saveSetting('active_shop_id', '');
    notifyListeners();
  }
}