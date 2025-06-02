import 'package:civiceye/core/themes/app_colors.dart';
import 'package:civiceye/cubits/report_cubit/report_cubit.dart';
import 'package:civiceye/cubits/report_cubit/report_state.dart';
import 'package:civiceye/screens/assigned_report_screen.dart';
import 'package:civiceye/screens/report_details.dart';
import 'package:civiceye/widgets/custom_AppBar.dart';
import 'package:civiceye/widgets/custom_Drawer.dart';
import 'package:civiceye/widgets/custom_bottomNavBar.dart';
import 'package:civiceye/widgets/report_status_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ReportsCubit>().getReports();

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
      body: BlocBuilder<ReportsCubit, ReportsState>(
        builder: (context, state) {
          if (state is ReportsLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is ReportsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 40),
                  const SizedBox(height: 16),
                  Text('خطأ: ${state.message}', textAlign: TextAlign.center),
                ],
              ),
            );
          }

          if (state is ReportsLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<ReportsCubit>().getReports();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // البلاغ الجاري
                    const Padding(
                      padding: EdgeInsets.fromLTRB(12, 16, 12, 8),
                      child: Text('البلاغ الجاري',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    if (state.inProgressReport != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            title: Text(state.inProgressReport!.title),
                            subtitle: Text(
                              'الحالة: ${ReportsCubit.statusLabels[state.inProgressReport!.currentStatus] ?? state.inProgressReport!.currentStatus}',
                              style: const TextStyle(color: Color.fromARGB(255, 75, 75, 75)),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit,
                                  color: AppColors.primary),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ReportDetailsScreen(
                                      report: state.inProgressReport!,
                                      employeeId: context
                                              .read<ReportsCubit>()
                                              .employeeId
                                              ?.toString() ??
                                          '',
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      )
                    else
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'لا يوجد بلاغ جاري حالياً',
                          style: TextStyle(color:  Color.fromARGB(255, 65, 65, 65)),
                        ),
                      ),

                    const SizedBox(height: 16),

                    // الإحصائيات
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text('إحصائيات البلاغات',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children:
                            state.reportCountsByStatus.entries.where((entry) => entry.key != 'Cancelled').map((entry) {
                          return StatsCard(
                            statusKey: entry.key,
                            title: ReportsCubit.statusLabels[entry.key] ??
                                entry.key,
                            count: entry.value,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ReportsScreen(),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                    ),

                    // أحدث البلاغات
                    const Padding(
                      padding: EdgeInsets.fromLTRB(12, 16, 12, 8),
                      child: Text('أحدث البلاغات',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    if (state.latestReports.isNotEmpty)
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.latestReports.length,
                        itemBuilder: (context, index) {
                          final report = state.latestReports[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                title: Text(report.title),
                                subtitle: Text(
                                  'الحالة: ${ReportsCubit.statusLabels[report.currentStatus] ?? report.currentStatus}',
                                  style: const TextStyle(color: Color.fromARGB(255, 65, 65, 65)),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ReportDetailsScreen(
                                        report: report,
                                        employeeId: context
                                                .read<ReportsCubit>()
                                                .employeeId
                                                ?.toString() ??
                                            '',
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      )
                    else
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'لا توجد بلاغات حديثة حالياً.',
                          style: TextStyle(color: Color.fromARGB(255, 65, 65, 65)),
                        ),
                      ),

                    const SizedBox(height: 24),
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
}
