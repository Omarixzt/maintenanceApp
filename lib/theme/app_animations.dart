import 'package:flutter/material.dart';

class AppAnimations {
  // 1. التوقيتات القياسية
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);

  // 2. المنحنيات (Curves) لحركة ناعمة وغير خطية
  static const Curve smoothIn = Curves.easeOutCubic;
  static const Curve smoothOut = Curves.easeInCubic;
  static const Curve bouncy = Curves.elasticOut;

  // 3. ثيم التنقل بين الصفحات (يُضاف في MaterialApp)
  static const PageTransitionsTheme pageTransitions = PageTransitionsTheme(
    builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  );

  // 4. دالة جاهزة لإنشاء حركة مخصصة عند الانتقال لصفحة (مثال: التلاشي)
  static Route fadeRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: normal,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: smoothIn),
          child: child,
        );
      },
    );
  }
}