// import 'package:civiceye/cubits/report_cubit/report_cubit.dart';
// import 'package:civiceye/report_status_enum.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class StatusFilter extends StatelessWidget {
//   final int employeeId;

//   const StatusFilter({super.key, required this.employeeId});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ReportCubit, ReportState>(
//       builder: (context, state) {
//         return SizedBox(
//           height: 50,
//           child: ListView.separated(
//             scrollDirection: Axis.horizontal,
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//             itemCount: ReportStatus.values.length,
//             separatorBuilder: (_, __) => const SizedBox(width: 4),
//             itemBuilder: (context, index) {
//               final status = ReportStatus.values[index];
//               final isSelected = state.selectedStatus == status;

//               return ChoiceChip(
//                 label: Text(status.name),
//                 selected: isSelected,
//                 onSelected: (_) {
//                   context.read<ReportCubit>().changeStatusFilter(
//                     status,
//                     employeeId,
//                   );
//                 },
//                 selectedColor: Theme.of(context).colorScheme.primary,
//                 labelStyle: TextStyle(
//                   color: isSelected
//                       ? Theme.of(context).colorScheme.onPrimary
//                       : Theme.of(context).colorScheme.onSurface,
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
// }
