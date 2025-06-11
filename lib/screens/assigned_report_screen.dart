import 'package:civiceye/core/storage/cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:civiceye/cubits/report_cubit/report_cubit.dart';
import 'package:civiceye/cubits/report_cubit/report_state.dart';
import 'package:civiceye/screens/report_details.dart';
import 'package:civiceye/widgets/app_error_widget.dart';
import 'package:civiceye/widgets/custom_AppBar.dart';
import 'package:civiceye/widgets/custom_Drawer.dart';
import 'package:civiceye/widgets/custom_bottomNavBar.dart';
import '../widgets/filter_bar.dart';
import '../widgets/report_card.dart';
import '../animations/reports_animation.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

const Map<String, String> statusLabels = {
  'All': 'الكل',
  'Submitted': 'تم الأستلام',
  'In_Progress': 'قيد التنفيذ',
  'On_Hold': 'قيد الأنتظار',
  'Resolved': 'تم الحل',
  'Cancelled': 'تم الالغاء',
};

class _ReportsScreenState extends State<ReportsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<ReportsCubit>().getReports();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final cubit = context.read<ReportsCubit>();
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 300 &&
        cubit.state is! ReportsLoading) {
      cubit.loadMoreReports();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final cubit = context.read<ReportsCubit>();

    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) Navigator.pushReplacementNamed(context, '/home');
          if (index == 2) Navigator.pushReplacementNamed(context, '/profile');
        },
      ),
      body: Column(
        children: [
          _buildStatusFilterBar(cubit, colorScheme),
          Expanded(
            child: BlocBuilder<ReportsCubit, ReportsState>(
              builder: (context, state) {
                final reports = state is ReportsLoaded ? state.report : [];
                final hasMore = state is ReportsLoaded ? state.hasMore : false;

                if (state is ReportsLoading && reports.isEmpty) {
                  return _buildShimmerList();
                }

                if (state is ReportsError) {
                  return AppErrorWidget(message: state.message);
                }

                if (reports.isEmpty) {
                  return const Center(child: Text('لا توجد بلاغات'));
                }

                return RefreshIndicator(
                  onRefresh: () => cubit.getReports(),
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: hasMore ? reports.length + 1 : reports.length,
                    itemBuilder: (context, index) {
                      if (index >= reports.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final report = reports[index];
                      return _buildReportCard(report, colorScheme);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusFilterBar(ReportsCubit cubit, ColorScheme colorScheme) {
    return FilterBar(
      cubit: cubit,
      colorScheme: colorScheme,
      parentContext: context,
    );
  }

  Widget _buildReportCard(dynamic report, ColorScheme colorScheme) {
    return ReportCard(
      report: report,
      colorScheme: colorScheme,
      onTap: () async {
        // جلب id الموظف الحالي
        final employee = await LocalStorageHelper.getEmployee();
        final employeeId = employee?.id.toString() ?? '';
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ReportDetailsScreen(
              report: report,
              reportId: report.reportId,
              employeeId: employeeId,
            ),
          ),
        );
      },
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemCount: 6,
      itemBuilder: (context, index) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: ShimmerReportCard(),
      ),
    );
  }
}
