import 'package:civiceye/features/reports/logic/report_state.dart';
import 'package:civiceye/models/report_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:civiceye/features/reports/logic/report_cubit.dart';
class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _ = Theme.of(context).colorScheme;
    final _ = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('البلاغات'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: BlocBuilder<ReportsCubit, ReportsState>(
        builder: (context, state) {
          if (state is ReportsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ReportsLoaded) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      FilterChip(
                        label: const Text('الكل'),
                        selected: state.filters.isEmpty,
                        onSelected: (_) => context.read<ReportsCubit>().clearFilter(),
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: const Text('معلق'),
                        selected: state.filters.contains('معلق'),
                        onSelected: (_) => context.read<ReportsCubit>().filterBy('معلق'),
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: const Text('قيد التنفيذ'),
                        selected: state.filters.contains('قيد التنفيذ'),
                        onSelected: (_) => context.read<ReportsCubit>().filterBy('قيد التنفيذ'),
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: const Text('تم الحل'),
                        selected: state.filters.contains('تم الحل'),
                        onSelected: (_) => context.read<ReportsCubit>().filterBy('تم الحل'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: state.filteredReports.isEmpty
                      ? const Center(child: Text('لا توجد بلاغات'))
                      : ListView.builder(
                          itemCount: state.filteredReports.length,
                          itemBuilder: (context, index) {
                            final report = state.filteredReports[index];
                            return ReportCard(report: report);
                          },
                        ),
                ),
              ],
            );
          } else {
            return const Center(child: Text('حدث خطأ أثناء تحميل البلاغات'));
          }
        },
      ),
    );
  }
}

class ReportCard extends StatelessWidget {
  final ReportModel report;

  const ReportCard({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final _ = Theme.of(context).colorScheme;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ListTile(
        title: Text(report.title, style: textTheme.bodyLarge),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text("الحالة: ${report.currentStatus}", style: textTheme.bodyMedium),
            const SizedBox(height: 2),
            Text("تاريخ الإنشاء: ${DateFormat.yMd().format(report.createdAt)}", style: textTheme.bodySmall),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 20),
        onTap: () {
          Navigator.pushNamed(context, '/report_details', arguments: report);
        },
      ),
    );
  }
}
