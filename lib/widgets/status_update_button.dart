// import 'package:civiceye/cubits/report_cubit/report_detail_state.dart';
// import 'package:flutter/material.dart';
// import 'package:civiceye/models/report_model.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:civiceye/cubits/report_cubit/report_detail_cubit.dart';

// class StatusUpdateButton extends StatefulWidget {
//   final ReportModel report;
//   final String employeeId;

//   const StatusUpdateButton({super.key, required this.report, required this.employeeId});

//   @override
//   _StatusUpdateButtonState createState() => _StatusUpdateButtonState();
// }

// class _StatusUpdateButtonState extends State<StatusUpdateButton> {
//   final TextEditingController _notesController = TextEditingController();
//   String? selectedStatus;  // متغير لتخزين الحالة المختارة

//   void _showStatusDialog(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       builder: (_) => Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Wrap(
//           children: [
//             const Text('تحديث الحالة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 12),
//             // عرض قائمة الحالات المتاحة
//             ...['In Progress', 'On Hold', 'Resolved', 'Closed'].map(
//               (status) => ListTile(
//                 title: Text(status),
//                 onTap: () {
//                   setState(() {
//                     selectedStatus = status; // تخزين الحالة المختارة
//                   });
//                   Navigator.pop(context); // إغلاق الـ Dialog بعد اختيار الحالة
//                 },
//               ),
//             ).toList(), 
//             const SizedBox(height: 12),
//             // حقل الملاحظات
//             TextField(
//               controller: _notesController,
//               decoration: const InputDecoration(
//                 labelText: 'ملاحظات (اختياري)',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 12),
//             // زر تحديث الحالة
//             ElevatedButton(
//               onPressed: () {
//                 if (selectedStatus != null) {
//                   BlocProvider.of<ReportDetailCubit>(context).updateReportStatus(
//                     widget.report, // passing the entire report model
//                     selectedStatus!, // newStatus
//                     widget.employeeId, // employeeId
//                     (_notesController.text.trim().isEmpty ? null : _notesController.text.trim()) as int, // passing notes
//                   );
//                   Navigator.pop(context); // Close the dialog after updating
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('يرجى اختيار حالة لتحديثها')),
//                   );
//                 }
//               },
//               child: const Text('تحديث الحالة'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<ReportDetailCubit, ReportDetailState>(
//       listener: (context, state) {
//         // بعد التحديث، إظهار إشعار للمستخدم باستخدام SnackBar
//         if (state is ReportDetailUpdated) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('تم تحديث الحالة بنجاح')),
//           );
//         } else if (state is ReportDetailError) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('فشل في تحديث الحالة')),
//           );
//         }
//       },
//       builder: (context, state) {
//         // إذا كانت الحالة قيد التحديث، أظهر CircularProgressIndicator
//         if (state is ReportDetailLoading) {
//           return const CircularProgressIndicator(); // أو يمكن إرجاع زر مع مؤشر تحميل
//         }

//         return ElevatedButton.icon(
//           onPressed: () => _showStatusDialog(context),
//           icon: const Icon(Icons.edit),
//           label: const Text('تحديث الحالة'),
//         );
//       },
//     );
//   }
// }
