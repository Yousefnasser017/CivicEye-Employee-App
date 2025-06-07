// ignore_for_file: deprecated_member_use

import 'package:civiceye/core/themes/app_colors.dart';
import 'package:civiceye/widgets/SnackbarHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:civiceye/models/report_model.dart';
import 'package:civiceye/cubits/report_cubit/report_detail_cubit.dart';
import 'package:civiceye/cubits/report_cubit/report_detail_state.dart';
import 'package:civiceye/models/report_status_enum.dart';

class UpdateStatusDialog extends StatefulWidget {
  final ReportModel report;

  const UpdateStatusDialog({Key? key, required this.report}) : super(key: key);

  static Future<void> show({
    required BuildContext context,
    required ReportModel report,
  }) async {
    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'تحديث الحالة',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: UpdateStatusDialog(report: report),
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

  @override
  State<UpdateStatusDialog> createState() => _UpdateStatusDialogState();
}

class _UpdateStatusDialogState extends State<UpdateStatusDialog> {
  late TextEditingController notesController;
  late ReportStatus currentStatus;
  late List<ReportStatus> availableStatuses;
  late ReportStatus selectedStatus;

  @override
  void initState() {
    super.initState();
    notesController = TextEditingController();

    currentStatus = ReportStatus.values.firstWhere(
      (e) => e.name == widget.report.currentStatus,
      orElse: () => ReportStatus.Submitted,
    );

    availableStatuses = _getAvailableStatuses(currentStatus);
    selectedStatus = availableStatuses.isNotEmpty ? availableStatuses.first : currentStatus;
  }

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cubit = context.read<ReportDetailCubit>();

    return BlocListener<ReportDetailCubit, ReportDetailState>(
      listener: (context, state) {
        if (state is ReportDetailUpdated) {
          Navigator.of(context).pop();
          SnackBarHelper.show(context, 'تم تحديث الحالة بنجاح', type: SnackBarType.success);
        } else if (state is ReportDetailError) {
          SnackBarHelper.show(context, state.message, type: SnackBarType.error);
        }
      },
      child: AlertDialog(
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
        contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                'تحديث حالة البلاغ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: currentStatus.color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(currentStatus.icon, size: 16, color: currentStatus.color),
                  const SizedBox(width: 6),
                  Text(
                    'الحالة الحالية: ${currentStatus.label}',
                    style: TextStyle(
                      fontSize: 13,
                      color: currentStatus.color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButton<ReportStatus>(
                  dropdownColor: Theme.of(context).cardColor,
                  isExpanded: true,
                  value: selectedStatus,
                  underline: const SizedBox(),
                  icon: const Icon(Icons.arrow_drop_down),
                  items: availableStatuses.map((status) {
                    return DropdownMenuItem<ReportStatus>(
                      value: status,
                      child: Row(
                        children: [
                          Icon(status.icon, color: status.color, size: 18),
                          const SizedBox(width: 8),
                          Text(status.label),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    if (newValue != null) {
                      setState(() => selectedStatus = newValue);
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),

              if (selectedStatus != currentStatus)
                Row(
                  children: [
                    const Icon(Icons.arrow_forward, size: 18),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'سيتم التحديث إلى: ${selectedStatus.label}',
                        style: TextStyle(
                          color: selectedStatus.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 16),

              TextField(
                controller: notesController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  hintText: 'أدخل ملاحظاتك هنا...',
                  hintStyle: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black54,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        actions: [
          BlocBuilder<ReportDetailCubit, ReportDetailState>(
            builder: (context, state) {
              final isLoading = state is ReportDetailLoading;
              return Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color:AppColors.primary),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          
                        ),
                      ),
                      child: const Text('إلغاء'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isLoading || selectedStatus == currentStatus
                          ? null
                          : () {
                              cubit.updateReportStatus(
                                widget.report,
                                selectedStatus.name,
                                notesController.text.trim(),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:isLoading
                            ? Colors.white
                            : const Color(0xFF725DFE),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                                backgroundColor: AppColors.primary,
                            
                              ),
                            )
                          : const Text(
                              'تحديث',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  List<ReportStatus> _getAvailableStatuses(ReportStatus currentStatus) {
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
