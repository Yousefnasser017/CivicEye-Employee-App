// import 'package:flutter/material.dart';
// import 'package:civiceye/models/report_model.dart';

// class ReportInfoSection extends StatelessWidget {
//   final ReportModel report;

//   const ReportInfoSection({super.key, required this.report});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           report.title,
//           style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           report.description ?? 'لا يوجد وصف للبلاغ',
//           style: const TextStyle(fontSize: 16, color: Colors.black87),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           'الحالة الحالية: ${report.currentStatus}',  // عرض الحالة الحالية
//           style: const TextStyle(fontSize: 16, color: Colors.blue),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           'التاريخ: ${report.createdAt.toLocal().toString().substring(0, 19)}',  // عرض تاريخ الإنشاء
//           style: const TextStyle(fontSize: 16, color: Colors.black54),
//         ),
//       ],
//     );
//   }
// }
