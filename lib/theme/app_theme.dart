import 'package:flutter/material.dart';
import 'app_animations.dart'; // تأكد من استيراد ملف الحركات هنا

class AppTheme {
  // الألوان الأساسية الخاصة بالهوية (ALBAIK)
  static const Color albaikRichRed = Color(0xFFE31E24);
  static const Color albaikDeepNavy = Color(0xFF1D2836);
  static const Color albaikPureWhite = Colors.white;

  // إعدادات الثيم الشامل للتطبيق
  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: albaikPureWhite,
      primaryColor: albaikDeepNavy,
      
      // تضمين ثيم الحركات الموحد للتنقل بين الصفحات
      pageTransitionsTheme: AppAnimations.pageTransitions,

      // --- الإضافات الجديدة لتوحيد تأثير النقرات (Animations) ---
      splashColor: albaikRichRed.withOpacity(0.15), // لون تأثير التموج عند النقرة
      highlightColor: albaikDeepNavy.withOpacity(0.05), // لون الخلفية عند الضغط المطول

      // توحيد تصميم البطاقات لتتفاعل مع النقرات بشكل صحيح
      cardTheme: CardThemeData( // <-- تم التعديل هنا إلى CardThemeData
        color: albaikPureWhite,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.only(bottom: 12),
        clipBehavior: Clip.antiAlias, // هذا السطر ضروري ليظهر تأثير النقرة داخل حدود البطاقة فقط
      ),
      
      // توحيد تصميم الشريط العلوي (AppBar) في كل الواجهات
      appBarTheme: const AppBarTheme(
        backgroundColor: albaikPureWhite,
        foregroundColor: albaikDeepNavy,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: albaikDeepNavy),
        titleTextStyle: TextStyle(
          color: albaikDeepNavy, 
          fontWeight: FontWeight.w700, 
          fontSize: 20,
        ),
      ),

      // توحيد تصميم حقول الإدخال (TextFormField) في كل الواجهات
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: const TextStyle(color: albaikDeepNavy, fontWeight: FontWeight.w600),
        prefixIconColor: albaikDeepNavy.withOpacity(0.7),
        filled: true,
        fillColor: albaikPureWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: albaikDeepNavy.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: albaikDeepNavy.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: albaikRichRed, width: 2.0),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      ),

      // توحيد تصميم الأزرار الأساسية (ElevatedButton)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: albaikDeepNavy,
          foregroundColor: albaikPureWhite,
          padding: const EdgeInsets.symmetric(vertical: 20),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      
      // توحيد تصميم الأزرار الثانوية (OutlinedButton)
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: albaikDeepNavy,
          side: const BorderSide(color: albaikDeepNavy),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      // توحيد تصميم النوافذ المنبثقة (Bottom Sheets)
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: albaikPureWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
      ),
    );
  }
}