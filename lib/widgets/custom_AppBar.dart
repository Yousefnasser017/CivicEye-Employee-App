import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: AppBar(
        backgroundColor: const Color(0xFF725DFE),
        leadingWidth: 0, // يزيل الفراغ على اليسار
        titleSpacing: 0, // يزيل الفراغ حول العنوان
        title: Padding(
          padding: const EdgeInsets.only(left: 16), // يمكن ضبطه حسب الحاجة
          child: Image.asset(
            'assets/images/logo-white.png',
            height: 60,
            fit: BoxFit.contain,
            color: Colors.white,
          ),
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer(); 
              },
            ),
          ),
        ],
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
    );
  }
}