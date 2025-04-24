import 'package:civiceye/features/home/logic/home_cubit.dart';
import 'package:civiceye/widgets/custom_AppBar.dart';
import 'package:civiceye/widgets/custom_Drawer.dart';
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
          appBar: CustomAppBar(title: 'الصفحة الرئيسية'),
          drawer: const CustomDrawer(username: 'المستخدم'),
          body: state is HomeLoading
              ? const Center(child: CircularProgressIndicator())
              : state is HomeLoaded
                  ? SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            elevation: 3,
                            child: ListTile(
                              title: const Text('إجمالي البلاغات'),
                              trailing: Text('${state.totalReports}', style: const TextStyle(fontSize: 20)),
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (state.currentReport != null)
                            Card(
                              elevation: 3,
                              child: Column(
                                children: [
                                  ListTile(
                                    title: const Text('بلاغ جاري'),
                                    subtitle: Text(state.currentReport!.title),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton.icon(
                                      onPressed: () async {
                                        await context.read<HomeCubit>().updateStatus(
                                              state.currentReport!.reportId,
                                              'تم الحل',
                                            );

                                        if (mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('تم تحديث حالة البلاغ بنجاح'),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                        }
                                      },
                                      icon: const Icon(Icons.check),
                                      label: const Text('تم الانتهاء'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            const Text('لا يوجد بلاغ جاري حالياً'),
                        ],
                      ),
                    )
                  : const Center(child: Text('فشل تحميل البيانات')),
        );
      },
    );
  }
}
