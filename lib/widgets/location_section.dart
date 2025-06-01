// import 'package:civiceye/models/report_model.dart';
// import 'package:flutter/material.dart';
// import 'package:civiceye/screens/map_screen.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:civiceye/cubits/report_cubit/report_detail_cubit.dart';
// import 'package:civiceye/cubits/report_cubit/report_detail_state.dart';

// class LocationSection extends StatelessWidget {
//   final int reportId;

//   const LocationSection({super.key, required this.reportId, required ReportModel report});

//   void _openMapDialog(BuildContext context, double latitude, double longitude) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text('فتح الخريطة'),
//         content: const Text('هل ترغب في فتح الخريطة لموقع البلاغ؟'),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context), child: const Text('لا')),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => MapScreen(latitude: latitude, longitude: longitude),
//                 ),
//               );
//             },
//             child: const Text('نعم'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ReportDetailCubit, ReportDetailState>(
//       builder: (context, state) {
//         if (state is ReportDetailLoading) {
//           final report = state.report;
//           final latitude = report?.latitude ?? 0.0;
//           final longitude = report?.longitude ?? 0.0;

//           return GestureDetector(
//             onTap: () => _openMapDialog(context, latitude, longitude),
//             child: const Text(
//               'عرض الموقع على الخريطة',
//               style: TextStyle(fontSize: 16, color: Colors.blue),
//             ),
//           );
//         }

//         // حالة loading أو إذا كان هناك خطأ
//         return const Center(child: CircularProgressIndicator());
//       },
//     );
//   }
// }
