import 'package:civiceye/screens/assigned_report_screen.dart';
import 'package:civiceye/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animate_do/animate_do.dart';

import 'package:civiceye/core/themes/app_colors.dart';
import 'package:civiceye/cubits/profile_cubit/profile_cubit.dart';
import 'package:civiceye/widgets/custom_AppBar.dart';
import 'package:civiceye/widgets/custom_Drawer.dart';
import 'package:civiceye/widgets/custom_bottomNavBar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit()..loadProfile(),
      child: BlocBuilder<ProfileCubit, ProfileState>(
        buildWhen: (previous, current) => current is! ProfileLoading,
        builder: (context, state) {
          if (state is ProfileLoaded) {
            return Scaffold(
              appBar: const CustomAppBar(),
              drawer: const CustomDrawer(),
              bottomNavigationBar: CustomBottomNavBar(
                currentIndex: 2,
                onTap: (index) {
                  if (index == 0) {
                    Navigator.of(context)
                        .pushReplacement(_createRoute('/home'));
                  }
                  if (index == 1) {
                    Navigator.of(context)
                        .pushReplacement(_createRoute('/reports'));
                  }
                },
              ),
              body: _buildProfileBody(state, context),
            );
          } else if (state is ProfileError) {
            return Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () => context.read<ProfileCubit>().loadProfile(),
                  child: const Text('إعادة تحميل البيانات'),
                ),
              ),
            );
          } else {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }

  Widget _buildProfileBody(ProfileLoaded state, BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          FadeInUp(
            delay: const Duration(milliseconds: 300),
            child: _buildCard(
                Icons.person, "الاسم الكامل", state.fullName, context),
          ),
          const SizedBox(height: 16),
          FadeInUp(
            delay: const Duration(milliseconds: 400),
            child: _buildCard(Icons.email_outlined, "البريد الإلكتروني",
                state.email, context),
          ),
          const SizedBox(height: 16),
          FadeInUp(
            delay: const Duration(milliseconds: 500),
            child: _buildCard(
                Icons.location_on_outlined, "العنوان", state.address, context),
          ),
          const SizedBox(height: 16),
          FadeInUp(
            delay: const Duration(milliseconds: 600),
            child: _buildCard(
              _getIconForDepartment(state.department),
              "القسم",
              state.department,
              context,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
      IconData icon, String title, String value, BuildContext context) {
    final theme = Theme.of(context);
    final isDarkmode = theme.brightness == Brightness.dark;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isDarkmode ? Colors.grey[850] : Colors.white,
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDarkmode ? Colors.white : Colors.black,
            )),
        subtitle: Text(value,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: isDarkmode ? Colors.white : Colors.black,
            )),
      ),
    );
  }

  IconData _getIconForDepartment(String? department) {
    switch (department) {
      case 'Roads_and_Transportation_Department':
        return Icons.directions_car;
      case 'Electricity_Authority':
        return Icons.electric_bolt;
      case 'Water_and_Sewage_Authority':
        return Icons.water;
      case 'Waste_Management_and_Sanitation_Authority':
        return Icons.delete;
      case 'Environmental_Affairs_Authority':
        return Icons.nature;
      case 'Telecommunication_Authority':
        return Icons.phone;
      case 'Housing_and_Utilities_Department':
        return Icons.house;
      case 'Administrative_Complaints_and_Customer_Service':
        return Icons.headset_mic;
      default:
        return Icons.business;
    }
  }

  Route _createRoute(String routeName) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          _getScreenForRoute(routeName),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 0.1);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        final fade = Tween<double>(begin: 0.0, end: 1.0).animate(animation);

        return SlideTransition(
          position: animation.drive(tween),
          child: FadeTransition(opacity: fade, child: child),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  Widget _getScreenForRoute(String routeName) {
    switch (routeName) {
      case '/home':
        return const HomeScreen();
      case '/reports':
        return const ReportsScreen();
      default:
        return const Scaffold(body: Center(child: Text("Not Found 404")));
    }
  }
}
