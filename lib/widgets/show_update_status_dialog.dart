// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:civiceye/models/report_model.dart';
import 'package:civiceye/cubits/report_cubit/report_detail_cubit.dart';
import 'package:civiceye/cubits/report_cubit/report_detail_state.dart';
import 'package:civiceye/models/report_status_enum.dart';

class UpdateStatusDialog {
  static Future<void> show({
    required BuildContext context,
    required ReportModel report,
    required int employeeId,
  }) async {
    final cubit = context.read<ReportDetailCubit>();
    final TextEditingController notesController = TextEditingController();

    final currentStatus = ReportStatus.values.firstWhere(
      (e) => e.name == report.currentStatus,
      orElse: () => ReportStatus.Submitted,
    );

    final availableStatuses = _getAvailableStatuses(currentStatus);
    ReportStatus selectedStatus = availableStatuses.first;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'تحديث الحالة',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('تحديث حالة البلاغ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: currentStatus.color.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(currentStatus.icon,
                                  size: 16, color: currentStatus.color),
                              const SizedBox(width: 4),
                              Text(
                                'الحالة الحالية: ${currentStatus.label}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: currentStatus.color,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.black : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: DropdownButton<ReportStatus>(
                        dropdownColor:  isDarkMode ? Colors.black : Colors.white,
                        isExpanded: true,
                        value: selectedStatus,
                        icon: const Icon(Icons.arrow_drop_down),
                        underline: const SizedBox(),
                        items: availableStatuses.map((status) {
                          return DropdownMenuItem<ReportStatus>(
                            value: status,
                            child: Row(
                              children: [
                                Icon(status.icon,
                                    color: status.color, size: 18),
                                const SizedBox(width: 10),
                                Text(status.label),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (ReportStatus? newValue) {
                          if (newValue != null) {
                            setState(() => selectedStatus = newValue);
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (selectedStatus != currentStatus)
                      Text(
                        'سيتم التحديث إلى: ${selectedStatus.label}',
                        style: TextStyle(
                            color: selectedStatus.color,
                            fontWeight: FontWeight.bold,
                            fontSize: 13),
                      ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: notesController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: isDarkMode? Colors.black: Colors.white,
                        hintText: 'أدخل ملاحظاتك هنا...',
                        hintStyle: TextStyle(
                          color: isDarkMode ? Colors.white70 : Colors.black54,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                    ),
                  ],
                ),
                actions: [
                  BlocBuilder<ReportDetailCubit, ReportDetailState>(
                    builder: (context, state) {
                      final isLoading = state is ReportDetailLoading;

                      return Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('إلغاء'),
                            ),
                          ),
                          const SizedBox(width: 8),
                     Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF725DFE),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      if (selectedStatus != currentStatus) {
                                        cubit.updateReportStatus(
                                          report,
                                          selectedStatus.name,
                                          notesController.text.trim(),
                                        );
                                      }
                                    },
                              child: isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      'تحديث',
                                      style: TextStyle(color: Colors.white),
                                    ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              );
            },
          ),
        );
      },
      transitionBuilder: (context, animation, _, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutBack,
          ),
          child: child,
        );
      },
    );
  }

 static List<ReportStatus> _getAvailableStatuses(ReportStatus currentStatus) {
    final List<ReportStatus> available = [];

    switch (currentStatus) {
      case ReportStatus.Submitted:
        available.add(ReportStatus.In_Progress);
        break;
      case ReportStatus.In_Progress:
        available.addAll([
          ReportStatus.On_Hold,
          ReportStatus.Resolved,
          ReportStatus.Cancelled,
        ]);
        break;
      case ReportStatus.On_Hold:
        available.add(ReportStatus.In_Progress);
        break;
      case ReportStatus.Resolved:
      case ReportStatus.Cancelled:

        break;
    }

    return available;
  }

}
