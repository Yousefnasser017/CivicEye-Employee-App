// import 'package:civiceye/cubits/home_cubit/home_state.dart';
// import 'package:flutter/material.dart';
// import 'package:timeline_tile/timeline_tile.dart'; // مكتبة timeline_tile

// class ReportTimeline extends StatelessWidget {
//   final ReportStatus currentStatus;

//   const ReportTimeline({super.key, required this.currentStatus});

//   bool _isReached(ReportStatus step) => currentStatus.index >= step.index;

//   @override
//   Widget build(BuildContext context) {
//     final steps = [
//       ReportStatus.submitted,
//       ReportStatus.inProgress,
//       ReportStatus.onHold,
//       ReportStatus.resolved,
//       ReportStatus.closed,
//     ];

//     return Column(
//       children: List.generate(steps.length, (index) {
//         final status = steps[index];
//         final isLast = index == steps.length - 1;
//         final isReached = _isReached(status);

//         return TimelineTile(
//           alignment: TimelineAlign.start,
//           isLast: isLast,
//           indicatorStyle: IndicatorStyle(
//             width: 20,
//             color: isReached ? Colors.blue : Colors.grey,
//             iconStyle: IconStyle(
//               iconData: isReached ? Icons.check_circle : Icons.radio_button_unchecked,
//               color: Colors.white,
//             ),
//           ),
//           beforeLineStyle: LineStyle(
//             color: isReached ? Colors.blue : Colors.grey.shade300,
//             thickness: 3,
//           ),
//           endChild: Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Text(
//               status.label,
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: isReached ? Colors.black : Colors.grey,
//               ),
//             ),
//           ),
//         );
//       }),
//     );
//   }
// }
