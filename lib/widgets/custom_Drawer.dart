import 'package:civiceye/features/auth/logic/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:civiceye/core/themes/cubit/theme_cubit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomDrawer extends StatelessWidget {
  final String username;
  const CustomDrawer({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDrawerHeader(colorScheme),
            _buildMenuItems(context),
            const Spacer(),
            _buildLogoutButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader(ColorScheme colorScheme) {
    return DrawerHeader(
      decoration: BoxDecoration(color: colorScheme.primary),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('assets/images/logo-white.png', width: 100, height: 100),
          const SizedBox(height: 10),
          Text('أهلاً، $username',
              style: const TextStyle(color: Colors.white, fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    return Column(
      children: [
        _buildListTile(
          icon: Icons.home,
          title: 'الرئيسية',
          onTap: () => Navigator.pushNamed(context, '/home'),
        ),
        _buildListTile(
          icon: Icons.assignment,
          title: 'البلاغات',
          onTap: () => Navigator.pushNamed(context, '/reports'),
        ),
        _buildListTile(
          icon: Icons.person,
          title: 'الملف الشخصي',
          onTap: () => Navigator.pushNamed(context, '/profile'),
        ),
        _buildListTile(
          icon: Icons.info,
          title: 'حول التطبيق',
          onTap: () => Navigator.pushNamed(context, '/about'),
        ),
        _buildThemeSwitch(context),
      ],
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  Widget _buildThemeSwitch(BuildContext context) {
    return SwitchListTile(
      title: const Text('الوضع الداكن'),
      secondary: const Icon(Icons.dark_mode),
      value: Theme.of(context).brightness == Brightness.dark,
      onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: const Icon(Icons.logout, color: Colors.red),
        title: const Text('تسجيل الخروج'),
        onTap: () => _showLogoutConfirmationDialog(context),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد تسجيل الخروج'),
        content: const Text('هل أنت متأكد أنك تريد تسجيل الخروج؟'),
        actions: [
          TextButton(
            child: const Text('إلغاء'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('تأكيد الخروج'),
            onPressed: () => _performLogout(context),
          ),
        ],
      ),
    );
  }

  Future<void> _performLogout(BuildContext context) async {
    Navigator.of(context).pop(); // إغلاق الـ Dialog أولاً
    
    try {
      await context.read<LoginCubit>().logout();
      
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/login',
          (route) => false,
        );
        
        Fluttertoast.showToast(
          msg: 'تم تسجيل الخروج بنجاح',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } catch (e) {
      if (context.mounted) {
        Fluttertoast.showToast(
          msg: 'حدث خطأ أثناء تسجيل الخروج',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
        );
      }
    }
  }
}