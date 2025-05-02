
// import 'package:civiceye/cubits/report_cubit/report_cubit.dart';
// import 'package:flutter/material.dart';
// import 'package:civiceye/models/report_model.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class InProgressCard extends StatelessWidget {
//   final ReportModel report;
//   final int employeeId;

//   const InProgressCard({
//     super.key,
//     required this.report,
//     required this.employeeId,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: ListTile(
//         title: Text(report.title),
//         subtitle: Text('الحالة: ${report.currentStatus}'),
//         trailing: ElevatedButton(
//           onPressed: () {
//             context.read<ReportsCubit>().updateRtatus(
//               reportId: report.reportId,
//               newStatus: 'Resolved',
//               employeeId: employeeId,
//               notes: 'تمت المعالجة',
//             ).then((_) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('تم تحديث الحالة بنجاح')),
//               );
//             });
//           },
//           child: const Text('إنهاء المعالجة'),
//         ),
//       ),
//     );
//   }
// }

