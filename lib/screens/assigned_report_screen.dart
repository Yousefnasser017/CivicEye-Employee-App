import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:civiceye/cubits/report_cubit/report_cubit.dart';
import 'package:civiceye/cubits/report_cubit/report_state.dart';
import 'package:civiceye/screens/report_details.dart';
import 'package:civiceye/widgets/app_error_widget.dart';
import 'package:civiceye/widgets/custom_AppBar.dart';
import 'package:civiceye/widgets/custom_Drawer.dart';
import 'package:civiceye/widgets/custom_bottomNavBar.dart';
import 'package:shimmer/shimmer.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

// ثابت عام لترجمة الحالات
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
    return SizedBox(
      height: 80,
      child: BlocBuilder<ReportsCubit, ReportsState>(
        builder: (context, state) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: cubit.statusFilters.length,
            itemBuilder: (context, index) {
              final status = cubit.statusFilters[index];
              final isSelected = status == cubit.selectedStatus;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ChoiceChip(
                  label: Text(
                    statusLabels[status] ?? status,
                    style: TextStyle(
                      color: isSelected
                          ? colorScheme.onPrimary
                          : colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (_) => cubit.filterByStatus(status),
                  selectedColor: colorScheme.primary,
                  backgroundColor: colorScheme.surfaceVariant,
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildReportCard(dynamic report, ColorScheme colorScheme) {
    final formattedDate = DateFormat('dd/MM/yyyy').format(report.createdAt);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) => SlideTransition(
        position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
            .animate(animation),
        child: FadeTransition(opacity: animation, child: child),
      ),
      child: Padding(
        key: ValueKey(report.reportId),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ReportDetailsScreen(
                  report: report,
                  reportId: report.reportId,
                  employeeId:
                      context.read<ReportsCubit>().employeeId?.toString() ?? '',
                ),
              ),
            );
          },
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            tween: Tween<double>(begin: 0.95, end: 1),
            builder: (context, scale, child) =>
                Transform.scale(scale: scale, child: child),
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    report.title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  if (report.description?.isNotEmpty == true) ...[
                    const SizedBox(height: 8),
                    Text(
                      report.description!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatusBadge(report.currentStatus, colorScheme),
                      Text(
                        formattedDate,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontSize: 13,
                              color: colorScheme.onSurface.withOpacity(0.6),
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status, ColorScheme colorScheme) {
    final color = _statusColor(status);
    final icon = _statusIcon(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            statusLabels[status] ?? status,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'Submitted':
        return Icons.upload_file;
      case 'In_Progress':
        return Icons.autorenew;
      case 'On_Hold':
        return Icons.pause_circle_filled;
      case 'Resolved':
        return Icons.check_circle;
      case 'Cancelled':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Submitted':
        return Colors.blue;
      case 'In_Progress':
        return Colors.orange;
      case 'On_Hold':
        return Colors.amber;
      case 'Resolved':
        return Colors.green;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemCount: 6,
      itemBuilder: (context, index) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: _ShimmerReportCard(),
      ),
    );
  }
}

class _ShimmerReportCard extends StatelessWidget {
  const _ShimmerReportCard();

  @override
  Widget build(BuildContext context) {
    final baseColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[700]!
        : Colors.grey[300]!;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: Colors.white,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
