// import 'package:civiceye/cubits/report_cubit/report_cubit.dart';
// import 'package:civiceye/screens/report_details.dart';
// import 'package:civiceye/widgets/app_loading.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';

// class ReportList extends StatelessWidget {
//   final ScrollController scrollController;
//   final int employeeId;

//   const ReportList({
//     super.key,
//     required this.scrollController,
//     required this.employeeId,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ReportCubit, ReportState>(
//       builder: (context, state) {
//         if (state.isLoading && state.reports.isEmpty) {
//           return const AppLoading();
//         } else if (state.isLoading && state.reports.isNotEmpty) {
//         } else if (state.reports.isEmpty) {
//           return const Center(child: Text('لا توجد بلاغات'));
//         }

//         return RefreshIndicator(
//           onRefresh: () => context.read<ReportCubit>().refreshReports(employeeId),
//           child: ListView.builder(
//             controller: scrollController,
//             itemCount: state.hasMore ? state.reports.length + 1 : state.reports.length,
//             itemBuilder: (context, index) {
//               if (index >= state.reports.length) {
//                 return const Padding(
//                   padding: EdgeInsets.all(16.0),
//                   child: Center(child: CircularProgressIndicator()),
//                 );
//               }

//               final report = state.reports[index];

//               return Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                 child: GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => ReportDetailScreen(report: report),
//                       ),
//                     );
//                   },
//                   child: Card(
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                     elevation: 2,
//                     color: Theme.of(context).cardColor,
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             report.title,
//                             style: Theme.of(context).textTheme.titleMedium,
//                           ),
//                           if (report.description != null) ...[
//                             const SizedBox(height: 8),
//                             Text(
//                               report.description!,
//                               style: Theme.of(context).textTheme.bodyMedium,
//                             ),
//                           ],
//                           const SizedBox(height: 12),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 report.currentStatus,
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: _statusColor(report.currentStatus, Theme.of(context).colorScheme),
//                                 ),
//                               ),
//                               Text(
//                                 DateFormat('dd/MM/yyyy').format(report.createdAt),
//                                 style: Theme.of(context).textTheme.labelSmall,
//                               ),
//                             ],
//                           ),
//                           if (report.currentStatus == 'In Progress') ...[
//                             const SizedBox(height: 12),
//                             Align(
//                               alignment: Alignment.centerRight,
//                               child: ElevatedButton(
//                                 onPressed: () {
//                                   context.read<ReportCubit>().updateReportStatus(
//                                     reportId: report.reportId,
//                                     newStatus: 'Resolved',
//                                     employeeId: employeeId,
//                                     notes: 'تمت المعالجة',
//                                   ).then((_) {
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       const SnackBar(content: Text('تم إنهاء المعالجة بنجاح')),
//                                     );
//                                   });
//                                 },
//                                 child: const Text('إنهاء المعالجة'),
//                               ),
//                             ),
//                           ],
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }

//   Color _statusColor(String status, ColorScheme colorScheme) {
//     switch (status) {
//       case 'Submitted':
//         return colorScheme.secondary;
//       case 'In Progress':
//         return colorScheme.primary;
//       case 'On Hold':
//         return Colors.amber;
//       case 'Resolved':
//         return Colors.green;
//       case 'Re_Solved':
//         return Colors.teal;
//       case 'Closed':
//         return colorScheme.error;
//       default:
//         return colorScheme.onSurface;
//     }
//   }
// }
