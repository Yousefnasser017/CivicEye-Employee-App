import 'package:civiceye/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const CustomBottomNavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor:AppColors.primary ,
      unselectedItemColor:isDarkMode ? Colors.white : const Color.fromARGB(255, 73, 73, 73),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
        BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'البلاغات'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'الملف الشخصي'),
      ],
    );
  }
}
