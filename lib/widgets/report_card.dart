// import 'package:flutter/material.dart';
// import 'package:civiceye/models/report_model.dart';

// class ReportCard extends StatelessWidget {
//   final ReportModel report;
//   final VoidCallback? onTap;

//   const ReportCard({super.key, required this.report, this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     final cardColor = isDarkMode ? Colors.grey[800] : Colors.white;
//     final textColor = isDarkMode ? Colors.white : Colors.black;
//     final subtitleColor = isDarkMode ? Colors.grey[300] : Colors.black54;

//     return Card(
//       elevation: 4,
//       margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       color: cardColor,
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(12),  // تجعل المنطقة التفاعلية مستديرة
//         child: ListTile(
//           title: Text(
//             report.title,
//             style: TextStyle(
//               color: textColor,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           subtitle: Text(
//             'الحالة: ${report.currentStatus}',
//             style: TextStyle(
//               color: subtitleColor,
//             ),
//           ),
//           trailing: const Icon(
//             Icons.arrow_forward_ios,
//             size: 16,
//           ),
//         ),
//       ),
//     );
//   }
// }
