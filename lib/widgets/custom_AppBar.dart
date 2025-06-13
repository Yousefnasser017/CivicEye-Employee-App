// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 8);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF725DFE), Color(0xFF5D8EFE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leadingWidth: 10,
          titleSpacing: 10,
          centerTitle: false,
          title: Image.asset(
            'assets/images/logo-white.png',
            height: 50,
            fit: BoxFit.contain,
            color: Colors.white,
          ),
          actions: [
            // إشعارات أولاً مع خلفية
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () {
                    Navigator.pushNamed(context, '/notifications');
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.notifications,
                        color: Color(0xFF725DFE)),
                  ),
                ),
              ),
            ),
            // القائمة الجانبية بعد الإشعارات مع خلفية
            Builder(
              builder: (context) => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () {
                      Scaffold.of(context).openDrawer();
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
                        shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.menu, color: Color(0xFF725DFE)),
                    ),
                  ),
                ),
              ),
            ),
          ],
          automaticallyImplyLeading: false,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
      ),
    );
  }
}
