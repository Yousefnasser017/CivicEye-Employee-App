// ignore_for_file: use_build_context_synchronously

import 'package:civiceye/core/storage/cache_helper.dart';
import 'package:civiceye/core/themes/app_colors.dart';
import 'package:civiceye/cubits/auth_cubit/auth_cubit.dart';
import 'package:civiceye/cubits/auth_cubit/auth_state.dart';
import 'package:civiceye/cubits/report_cubit/report_cubit.dart';
import 'package:civiceye/cubits/theme_cubit/theme_cubit.dart';
import 'package:civiceye/screens/sign_in.dart';
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
    final data = await LocalStorageHelper.getEmployee();
    if (data != null) {
      setState(() {
        fullName = data.fullName;
      });
    }
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
    final screenHeight = MediaQuery.of(context).size.height;
    final headerHeight = screenHeight * 0.25; // 25% of screen height

    return Container(
      height: headerHeight,
      width: double.infinity,
      decoration: BoxDecoration(color: color),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/logo-white.png',
            width: 150,
            height: 80,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 10),
          Text(
            'أهلاً، $fullName',
            style: const TextStyle(
              color: AppColors.appBarLight,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
      title: const Text('الوضع الليلى'),
      secondary: const Icon(Icons.dark_mode),
      value: isDarkMode,
      onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading:
            const Icon(Icons.logout, color: Color.fromARGB(255, 255, 17, 0)),
        title: const Text('تسجيل الخروج'),
        onTap: () => _showLogoutConfirmationDialog(context),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
        contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
        actionsPadding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        title: const Row(
          children: [
            Icon(Icons.logout, color: Colors.red),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'تسجيل الخروج',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: const Text(
          'هل تريد تسجيل الخروج؟',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(color: Colors.grey[400]!),
                    foregroundColor:
                        isDarkMode ? Colors.grey[300] : Colors.grey[800],
                  ),
                  child: const Text('إلغاء', style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    final cubit = context.read<LoginCubit>();
                    await cubit.logout();
                    context.read<ReportsCubit>().clear();

                    if (!context.mounted) return;

                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => LoginScreen()),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('تأكيد', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
