
import 'package:civiceye/cubits/home_cubit/home_cubit.dart';
import 'package:civiceye/widgets/custom_AppBar.dart';
import 'package:civiceye/widgets/custom_Drawer.dart';
import 'package:civiceye/widgets/custom_bottomNavBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().loadDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
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
          body: state is HomeLoading
              ? const Center(child: CircularProgressIndicator())
              : state is HomeLoaded
                  ? SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildStatCard('البلاغات المعلقة', state.pendingCount, Icons.pending_actions, Colors.orange),
                          _buildStatCard('تم حلها', state.resolvedCount, Icons.check_circle, Colors.green),
                          _buildStatCard('بلاغات اليوم', state.todayCount, Icons.today, Colors.blueAccent),
                          const SizedBox(height: 20),
                          if (state.currentReport != null)
                            Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('البلاغ الجاري:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 8),
                                    Text(state.currentReport!.title, style: const TextStyle(fontSize: 16)),
                                    const SizedBox(height: 12),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        context.read<HomeCubit>().updateStatus(
                                          state.currentReport!.reportId,
                                          'تم الحل',
                                        );
                                      },
                                      icon: const Icon(Icons.check),
                                      label: const Text('تم الحل'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else
                            const Text('لا يوجد بلاغ جاري حالياً', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    )
                  : Center(child: Text((state as HomeError).message)),
        );
      },
    );
  }

  Widget _buildStatCard(String title, int count, IconData icon, Color color) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, size: 30, color: color),
        title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        trailing: Text('$count', style: const TextStyle(fontSize: 20)),
      ),
    );
  }
}