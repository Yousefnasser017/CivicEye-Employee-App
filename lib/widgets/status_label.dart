// import 'package:civiceye/report_status_enum.dart';
// import 'package:flutter/material.dart';


// class StatusLabel extends StatelessWidget {
//   final ReportStatus status;

//   const StatusLabel({super.key, required this.status});

//   Color get backgroundColor {
//     switch (status) {
//       case ReportStatus.Submitted:
//         return Colors.grey;
//       case ReportStatus.In_Progress:
//         return Colors.orange;
//       case ReportStatus.On_Hold:
//         return Colors.amber;
//       case ReportStatus.Resolved:
//         return Colors.green;
//       case ReportStatus.Cancelled:
//         return Colors.blueGrey;
    
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: backgroundColor.withOpacity(0.2),
//         border: Border.all(color: backgroundColor),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Text(
//         status.name,
//         style: TextStyle(
//           color: backgroundColor,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }
// }
