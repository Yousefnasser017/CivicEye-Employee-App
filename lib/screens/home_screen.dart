// ignore_for_file: deprecated_member_use
import 'package:civiceye/animations/home_screen_animation.dart';
import 'package:civiceye/core/themes/app_colors.dart';
import 'package:civiceye/cubits/report_cubit/report_cubit.dart';
import 'package:civiceye/cubits/report_cubit/report_state.dart';
import 'package:civiceye/screens/assigned_report_screen.dart';
import 'package:civiceye/screens/report_details.dart';
import 'package:civiceye/widgets/custom_AppBar.dart';
import 'package:civiceye/widgets/custom_Drawer.dart';
import 'package:civiceye/widgets/custom_bottomNavBar.dart';
import 'package:civiceye/widgets/report_count.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:timeago/timeago.dart' show ArMessages;
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ReportsCubit>().getReports();
    timeago.setLocaleMessages('ar', ArMessages());
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
            return const HomeScreenShimmer();
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
            final inProgressReport = state.inProgressReport;

            return RefreshIndicator(
              onRefresh: () async => context.read<ReportsCubit>().getReports(),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          Text(
                            '  البلاغ الجاري حالياً',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Divider(color: AppColors.primary.withOpacity(0.5), thickness: 1),
                          inProgressReport != null && inProgressReport.title.trim().isNotEmpty
                              ? _buildInProgressCard(context, inProgressReport)
                              : _buildEmptyMessage('لا يوجد بلاغ جاري حالياً'),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'إحصائيات البلاغات',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Divider(color: AppColors.primary.withOpacity(0.5), thickness: 1),
                          const SizedBox(height: 12),
                          GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            physics: const NeverScrollableScrollPhysics(),
                            childAspectRatio: 1.3,
                            children: state.reportCountsByStatus.entries
                                .where((e) => e.key != 'Cancelled')
                                .map((entry) => StatsCard(
                                      statusKey: entry.key,
                                      title: ReportsCubit.statusLabels[entry.key] ?? entry.key,
                                      count: entry.value,
                                      onTap: () => _navigateTo(context, const ReportsScreen()),
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'أحدث البلاغات',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Divider(color: AppColors.primary.withOpacity(0.5), thickness: 1),
                          if (state.latestReports.isNotEmpty)
                            ...state.latestReports.map((report) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Card(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    child: ListTile(
                                      title: Text(report.title),
                                      subtitle: Text(
                                        timeago.format(report.createdAt, locale: 'ar'),
                                        style: TextStyle(
                                          color: isDarkMode ? Colors.white70 : Colors.grey[700],
                                        ),
                                      ),
                                      trailing: const Icon(Icons.chevron_right, color: AppColors.primary),
                                      onTap: () => _navigateTo(
                                        context,
                                        ReportDetailsScreen(
                                          report: report,
                                          reportId: report.reportId,
                                          employeeId: context.read<ReportsCubit>().employeeId?.toString() ?? '',
                                        ),
                                      ),
                                    ),
                                  ),
                                ))
                          else
                            _buildEmptyMessage('لا توجد بلاغات حديثة حالياً.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildInProgressCard(BuildContext context, dynamic report) {
    IconData statusIcon = Icons.timelapse;
    Color statusColor = AppColors.primary;

    switch (report.currentStatus) {
      case 'On_Hold':
        statusIcon = Icons.pause_circle_filled;
        statusColor = Colors.orange;
        break;
      case 'Resolved':
        statusIcon = Icons.check_circle;
        statusColor = Colors.green;
        break;
      case 'In_Progress':
        statusIcon = Icons.timelapse;
        statusColor = const Color.fromARGB(255, 255, 175, 63);
        break;
      default:
        statusIcon = Icons.info;
    }

   return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: statusColor.withOpacity(0.5), width: 1),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(report.title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          'تاريخ البلاغ: ${DateFormat('dd/MM/yyyy').format(report.createdAt)}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: IconButton(
          icon: Icon(statusIcon, color: statusColor),
          onPressed: () => _navigateTo(
            context,
            ReportDetailsScreen(
              report: report,
              reportId: report.reportId,
              employeeId: context.read<ReportsCubit>().employeeId?.toString() ?? '',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyMessage(String text) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.withOpacity(0.1),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, animation, __, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.easeInOut));
          return SlideTransition(position: animation.drive(tween), child: child);
        },
      ),
    );
  }
}
