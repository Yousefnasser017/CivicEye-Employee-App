
import 'package:civiceye/cubits/report_cubit/report_cubit.dart';
import 'package:civiceye/cubits/report_cubit/report_state.dart';
import 'package:civiceye/screens/report_details.dart';
import 'package:civiceye/widgets/app_error_widget.dart';
import 'package:civiceye/widgets/custom_AppBar.dart';
import 'package:civiceye/widgets/custom_Drawer.dart';
import 'package:civiceye/widgets/custom_bottomNavBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final ScrollController _scrollController = ScrollController();

  final Map<String, String> statusLabels = const {
    'All': 'الكل',
    'Submitted': 'تم الأستلام',
    'In_Progress': 'قيد التنفيذ',
    'On_Hold': 'قيد الأنتظار',
    'Resolved': 'تم الحل',
    'Cancelled': 'تم الالغاء',
  };

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
          // الشريط الأفقي لفلترة الحالة
          SizedBox(
            height: 50,
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
          ),

          // قائمة البلاغات مع معالجة الحالات
          Expanded(
            child: BlocBuilder<ReportsCubit, ReportsState>(
              builder: (context, state) {
                if (state is ReportsLoading && state.report.isEmpty) {
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: _ShimmerReportCard(),
                        );
                    },
                  );
                } else if (state is ReportsError) {
                  return AppErrorWidget(message: state.message);
                } else if ((state is ReportsLoaded && state.report.isEmpty) ||
                    (state is ReportsLoading && state.report.isEmpty)) {
                  return const Center(child: Text('لا توجد بلاغات'));
                }

                // استخرج البلاغات وحالة المزيد
                final reports =
                    state is ReportsLoaded ? state.report : <dynamic>[];
                final hasMore = state is ReportsLoaded ? state.hasMore : false;

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

  Widget _buildReportCard(dynamic report, ColorScheme colorScheme) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    final formattedDate = formatter.format(report.createdAt);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
              .animate(animation),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
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
            builder: (context, scale, child) => Transform.scale(
              scale: scale,
              child: child,
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.surface,
                    Theme.of(context).colorScheme.surface,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
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
                  if (report.description != null &&
                      report.description!.isNotEmpty) ...[
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
    final color = _statusColor(status, context);
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

  Color _statusColor(String status, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (status) {
      case 'Submitted':
        return isDark ? Colors.blue[300]! : Colors.blue;
      case 'In_Progress':
        return isDark ? Colors.orange[300]! : Colors.orange;
      case 'On_Hold':
        return isDark ? Colors.amber[300]! : Colors.amber;
      case 'Resolved':
        return isDark ? Colors.green[300]! : Colors.green;
      case 'Cancelled':
        return isDark ? Colors.red[300]! : Colors.red;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  Widget _ShimmerReportCard() {
    final baseColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[700]!
        : Colors.grey[300]!;

    final highlightColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[500]!
        : Colors.grey[100]!;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 18, width: 150, color: Colors.white),
            const SizedBox(height: 10),
            Container(height: 14, width: double.infinity, color: Colors.white),
            const SizedBox(height: 6),
            Container(height: 14, width: double.infinity, color: Colors.white),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(height: 16, width: 80, color: Colors.white),
                Container(height: 14, width: 50, color: Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

  

