import 'package:civiceye/core/api/login_service.dart';
import 'package:civiceye/core/storage/cache_helper.dart';
import 'package:civiceye/core/themes/app_colors.dart';
import 'package:civiceye/cubits/auth_cubit/auth_cubit.dart';
import 'package:civiceye/cubits/auth_cubit/auth_state.dart';
import 'package:civiceye/cubits/theme_cubit/theme_cubit.dart';
import 'package:civiceye/widgets/SnackbarHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String fullName = 'جارٍ التحميل...';
  bool get isDarkMode => Theme.of(context).brightness == Brightness.dark;

  @override
  void initState() {
    super.initState();
    loadUsername();
  }

  Future<void> loadUsername() async {
    final data = await LocalStorageHelper.readEmployeeData();
    setState(() {
      fullName = data['fullName'] ?? 'غير معروف';
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LogoutSuccess) {
          SnackBarHelper.show(
            context,
            'تم تسجيل الخروج بنجاح',
            type: SnackBarType.success,
          );
          Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
        } else if (state is LogoutFailure) {
          SnackBarHelper.show(
            context,
            'فشل في تسجيل الخروج: ${state.errorMessage}',
            type: SnackBarType.error,
          );
        }
      },
      child: Drawer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildDrawerHeader(Theme.of(context).primaryColor),
              _buildMenuItems(context),
              const Spacer(),
              _buildLogoutButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerHeader(Color color) {
    return Container(
      height: 180,
      decoration: BoxDecoration(color: color),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.asset(
              'assets/images/logo-white.png',
              width: 150,
              height: 80,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              'أهلاً، $fullName',
              style: const TextStyle(
                color: AppColors.appBarLight,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
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
      value: isDarkMode,
      onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: const Icon(Icons.logout, color: Color.fromARGB(255, 255, 17, 0)),
        title: const Text('تسجيل الخروج'),
        onTap: () => _showLogoutConfirmationDialog(context),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'تأكيد تسجيل الخروج',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        content: Text(
          'هل تريد تسجيل الخروج؟',
          style: TextStyle(
            fontSize: 16,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        actions: [
          TextButton(
            child: const Text(
              'إلغاء',
              style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 255, 17, 0)),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
            child: const Text(
              'تأكيد',
              style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 255, 17, 0)),
            ),
            onPressed: () {
              AuthApi.logout(context);
              Navigator.pop(context); // يغلق الـ dialog
            },
          ),
        ],
      ),
    );
  }
}
