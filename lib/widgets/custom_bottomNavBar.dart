
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final bgColor = theme.bottomNavigationBarTheme.backgroundColor ??
        (isDarkMode ? const Color(0xFF23272F) : Colors.white);
    final selectedColor = theme.colorScheme.primary;
    final unselectedColor =
        theme.textTheme.bodySmall?.color?.withOpacity(0.7) ??
            (isDarkMode ? Colors.grey[400]! : Colors.grey[700]!);

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black26 : Colors.grey.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'الرئيسية',
                index: 0,
                selectedColor: selectedColor,
                unselectedColor: unselectedColor,
              ),
              _buildNavItem(
                icon: Icons.assignment_outlined,
                activeIcon: Icons.assignment,
                label: 'البلاغات',
                index: 1,
                selectedColor: selectedColor,
                unselectedColor: unselectedColor,
              ),
              _buildNavItem(
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'الملف الشخصي',
                index: 2,
                selectedColor: selectedColor,
                unselectedColor: unselectedColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    required Color selectedColor,
    required Color unselectedColor,
  }) {
    final bool isSelected = widget.currentIndex == index;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => widget.onTap(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: isSelected
                ? selectedColor.withOpacity(0.09)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 320),
                transitionBuilder: (child, anim) =>
                    ScaleTransition(scale: anim, child: child),
                child: Icon(
                  isSelected ? activeIcon : icon,
                  key: ValueKey(isSelected ? activeIcon : icon),
                  color: isSelected ? selectedColor : unselectedColor,
                  size: isSelected ? 28 : 24,
                ),
              ),
              const SizedBox(height: 2),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  color: isSelected ? selectedColor : unselectedColor,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 12,
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
