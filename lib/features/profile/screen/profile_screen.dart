import 'package:civiceye/features/profile/logic/profile_cubit.dart';
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
              endDrawer: const CustomDrawer(username: 'المستخدم'),
              bottomNavigationBar: CustomBottomNavBar(
                currentIndex: 2,
                onTap: (index) {
                  if (index == 0) Navigator.pushReplacementNamed(context, '/home');
                  if (index == 1) Navigator.pushReplacementNamed(context, '/reports');
                },
              ),
              body: RefreshIndicator(
                onRefresh: () => context.read<ProfileCubit>().loadProfile(),
                child: SingleChildScrollView(
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
                                  : [theme.primaryColor, theme.colorScheme.secondary],
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
                                style: textTheme.titleLarge?.copyWith(color: Colors.white),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                state.email,
                                style: textTheme.bodyMedium?.copyWith(color: Colors.white70),
                              ),
                              const SizedBox(height: 16),
                              LinearProgressIndicator(
                                value: state.progress,
                                backgroundColor: Colors.white24,
                                color: Colors.white,
                                minHeight: 6,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                state.progress == 0
                                    ? "لم تقم بحل أي بلاغ بعد."
                                    : 'نسبة الإنجاز: ${(state.progress * 100).toStringAsFixed(1)}% (${state.solvedReports}/${state.totalReports})',
                                style: textTheme.bodySmall?.copyWith(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      FadeInUp(
                        delay: const Duration(milliseconds: 300),
                        child: _buildCard(Icons.person, "الاسم الكامل", state.fullName, context),
                      ),
                      const SizedBox(height: 12),
                      FadeInUp(
                        delay: const Duration(milliseconds: 400),
                        child: _buildCard(Icons.email_outlined, "البريد الإلكتروني", state.email, context),
                      ),
                      const SizedBox(height: 12),
                      FadeInUp(
                        delay: const Duration(milliseconds: 500),
                        child: _buildCard(Icons.location_on_outlined, "العنوان", state.address, context),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            );
          }

          if (state is ProfileError) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.message),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => context.read<ProfileCubit>().loadProfile(),
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
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
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isDark ? Colors.grey[850] : Colors.white,
      child: ListTile(
        leading: Icon(icon, color: theme.colorScheme.primary),
        title: Text(title, style: theme.textTheme.titleMedium),
        subtitle: Text(value, style: theme.textTheme.bodyMedium),
      ),
    );
  }
}
