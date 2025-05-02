import 'package:civiceye/core/themes/app_colors.dart';
import 'package:civiceye/cubits/profile_cubit/profile_cubit.dart';
import 'package:civiceye/widgets/custom_AppBar.dart';
import 'package:civiceye/widgets/custom_Drawer.dart';
import 'package:civiceye/widgets/custom_bottomNavBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animate_do/animate_do.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit()..loadProfile(),
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          final theme = Theme.of(context);
          final isDark = theme.brightness == Brightness.dark;
          final textTheme = theme.textTheme;

          if (state is ProfileLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is ProfileLoaded) {
            return Scaffold(
              appBar: const CustomAppBar(),
              drawer: const CustomDrawer(),
              bottomNavigationBar: CustomBottomNavBar(
                currentIndex: 2,
                onTap: (index) {
                  if (index == 0) Navigator.pushReplacementNamed(context, '/home');
                  if (index == 1) Navigator.pushReplacementNamed(context, '/reports');
                },
              ),
              body:SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FadeInDown(
                        duration: const Duration(milliseconds: 600),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              colors: isDark
                                  ? [Colors.grey[900]!, Colors.grey[800]!]
                                  : [theme.primaryColor, theme.primaryColor.withOpacity(0.8)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.fullName,
                                style: textTheme.bodyLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              const SizedBox(height: 20),
                              LinearProgressIndicator(
                                value: state.progress,
                                backgroundColor: const Color.fromARGB(219, 248, 248, 248),
                                color: Colors.white,
                                minHeight: 6,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                state.progress == 0
                                    ? "لم تقم بحل أي بلاغ بعد."
                                    : 'نسبة الإنجاز: ${(state.progress * 100).toStringAsFixed(1)}% (${state.solvedReports}/${state.totalReports})',
                                style: textTheme.bodyMedium?.copyWith(color: const Color.fromARGB(240, 255, 255, 255), fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      FadeInUp(
                        delay: const Duration(milliseconds: 300),
                        child: _buildCard(Icons.person, "الاسم الكامل", state.fullName, context),
                      ),
                      const SizedBox(height: 16),
                      FadeInUp(
                        delay: const Duration(milliseconds: 400),
                        child: _buildCard(Icons.email_outlined, "البريد الإلكتروني", state.email, context),
                      ),
                      const SizedBox(height: 16),
                      FadeInUp(
                        delay: const Duration(milliseconds: 500),
                        child: _buildCard(Icons.location_on_outlined, "العنوان", state.address, context),
                      ),
                      const SizedBox(height: 16),
                      FadeInUp(
                        delay: const Duration(milliseconds: 600),
                        child: _buildCard(
                          _getIconForDepartment(state.department), // الأيقونة الافتراضية
                          "القسم", 
                          state.department, 
                          context,
                           // إضافة قيمة القسم
                        ),
                      ),
                    ],
                  ),
                ),
              );
            
          }

          if (state is ProfileError) {
           BlocProvider(
              create: (_) => ProfileCubit()..loadProfile(),
              child: Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<ProfileCubit>().loadProfile(); // هذا سيعمل طالما نحن داخل BlocProvider
                    },
                    child: const Text('إعادة تحميل البيانات'),
                  ),
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildCard(IconData icon, String title, String value, BuildContext context) {
    final theme = Theme.of(context);
    final isDarkmode = theme.brightness == Brightness.dark;

    // تعيين الأيقونة بناءً على القسم
    IconData sectionIcon = icon;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isDarkmode ? Colors.grey[850] : Colors.white,
      child: ListTile(
        leading: Icon(sectionIcon, color: AppColors.primary),
        title: Text(title, style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: isDarkmode ? Colors.white : Colors.black,
        )),
        subtitle: Text(value, style: theme.textTheme.bodyLarge?.copyWith(
          color: isDarkmode ? Colors.white : Colors.black,
        )),
      ),
    );
  }

  // دالة لتحديد الأيقونة بناءً على القسم
  IconData _getIconForDepartment(String? department) {
    if (department == null || department.isEmpty) {
      return Icons.business; // أيقونة افتراضية في حالة عدم وجود قسم
    }

    switch (department) {
      case 'Roads and Transportation':
        return Icons.directions_car;
      case 'Electricity Authority':
        return Icons.electric_bolt;
      case 'Water and Sewage Authority':
        return Icons.water;
      case 'Waste Management and Sanitation':
        return Icons.delete;
      case 'Environmental Affairs':
        return Icons.nature;
      case 'Telecommunication_Authority':
        return Icons.phone;
      case 'Housing and Utilities':
        return Icons.house;
      case 'Administrative Complaints':
        return Icons.headset_mic;
      default:
      print("Returning Default Icon: Icons.business");
        return Icons.business; // Icon for default case
    }
  }
}
