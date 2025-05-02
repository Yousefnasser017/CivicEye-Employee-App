
import 'package:civiceye/widgets/custom_AppBar.dart';
import 'package:civiceye/widgets/custom_Drawer.dart';
import 'package:civiceye/widgets/custom_bottomNavBar.dart';
import 'package:flutter/material.dart';



class ReportsScreen extends StatelessWidget {
  final int employeeId;

  const ReportsScreen({super.key, required this.employeeId});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) Navigator.pushReplacementNamed(context, '/reports');
          if (index == 2) Navigator.pushReplacementNamed(context, '/profile');
        },
      ),
      body: Text("hello"),
    );
  }
}
