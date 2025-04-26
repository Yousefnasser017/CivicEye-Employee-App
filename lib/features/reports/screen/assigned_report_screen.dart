// reports_screen.dart
import 'package:civiceye/widgets/custom_AppBar.dart';
import 'package:civiceye/widgets/custom_bottomNavBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../logic/report_cubit.dart';
import '../logic/report_state.dart';
import '../../../models/report_model.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 1, onTap: (index) {
        if (index == 0) Navigator.pushReplacementNamed(context, '/home');
        if (index == 2) Navigator.pushReplacementNamed(context, '/profile');
      }),
      body: BlocBuilder<ReportsCubit, ReportsState>(
        builder: (context, state) {
          if (state is ReportsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ReportsLoaded) {
            return RefreshIndicator(
              onRefresh: () => context.read<ReportsCubit>().refreshReports(),
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  const SizedBox(height: 8),
                  _buildFilters(context, state.filters),
                  const SizedBox(height: 8),
                  if (state.currentReport != null) _buildCurrentReportCard(context, state.currentReport!),
                  const SizedBox(height: 8),
                  if (state.filteredReports.isEmpty)
                    const Center(child: Padding(
                      padding: EdgeInsets.all(40),
                      child: Text('لا توجد بلاغات'),
                    ))
                  else
                    ...state.filteredReports.map((r) => _buildReportCard(context, r)),
                ],
              ),
            );
          } else {
            return const Center(child: Text('حدث خطأ أثناء تحميل البلاغات'));
          }
        },
      ),
    );
  }

  Widget _buildFilters(BuildContext context, List<String> active) {
    final cubit = context.read<ReportsCubit>();
    return Wrap(
      spacing: 8,
      children: [
        FilterChip(
          label: const Text("الكل"),
          selected: active.isEmpty,
          onSelected: (_) => cubit.clearFilter(),
        ),
        FilterChip(
          label: const Text("معلق"),
          selected: active.contains('معلق'),
          onSelected: (_) => cubit.filterBy('معلق'),
        ),
        FilterChip(
          label: const Text("تم الحل"),
          selected: active.contains('تم الحل'),
          onSelected: (_) => cubit.filterBy('تم الحل'),
        ),
      ],
    );
  }

  Widget _buildReportCard(BuildContext context, ReportModel report) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(report.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("الحالة: ${report.currentStatus}"),
            Text("تاريخ الإنشاء: ${DateFormat.yMd().format(report.createdAt)}"),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("جارٍ فتح تفاصيل البلاغ...")),
          );
          Navigator.pushNamed(context, '/report_details', arguments: report);
        },
      ),
    );
  }

  Widget _buildCurrentReportCard(BuildContext context, ReportModel report) {
    return Card(
      color: Colors.orange.shade50,
      elevation: 4,
      child: Column(
        children: [
          ListTile(
            title: const Text('بلاغ جاري'),
            subtitle: Text(report.title),
            trailing: const Icon(Icons.timer),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ElevatedButton.icon(
              onPressed: () => context.read<ReportsCubit>().markAsResolved(report),
              icon: const Icon(Icons.check),
              label: const Text('تم الحل'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
          ),
        ],
      ),
    );
  }
}
