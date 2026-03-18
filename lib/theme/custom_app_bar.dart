import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: Container(
        padding: const EdgeInsets.all(8.0),
        child: const CircleAvatar(
          backgroundColor: Colors.transparent,
          backgroundImage: AssetImage('lib/assets/logo.png'), 
        ),
      ),
    );
  }

  // هذا السطر إلزامي لأن AppBar يحتاج لمعرفة ارتفاعه المسبق
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}