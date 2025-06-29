// ignore_for_file: unused_local_variable, deprecated_member_use
import 'package:civiceye/core/themes/app_colors.dart';
import 'package:civiceye/cubits/report_cubit/report_cubit.dart';
import 'package:civiceye/widgets/SnackbarHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:civiceye/models/report_model.dart';
import 'package:civiceye/cubits/report_cubit/report_detail_cubit.dart';
import 'package:civiceye/cubits/report_cubit/report_detail_state.dart';
import 'package:civiceye/models/report_status_enum.dart';

class UpdateStatusDialog extends StatefulWidget {
  final ReportModel report;
  final int employeeId;
  final Future<bool?> Function(String newStatus, String? notes) onStatusUpdated;
  const UpdateStatusDialog({
    Key? key,
    required this.report,
    required this.employeeId,
    required this.onStatusUpdated,
  }) : super(key: key);

  static Future<(ReportStatus?, String?)> show({
    required BuildContext context,
    required ReportModel report,
    required int employeeId,
  }) async {
    final result = await showGeneralDialog<(ReportStatus?, String?)>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Update Status',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: UpdateStatusDialog(
            report: report,
            employeeId: employeeId,
            onStatusUpdated: (String newStatus, String? notes) async => true,
          ),
        );
      },
      transitionBuilder: (ctx, anim, _, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
          child: child,
        );
      },
    );

    return result ?? (null, null);
  }

  @override
  State<UpdateStatusDialog> createState() => _UpdateStatusDialogState();
}

class _UpdateStatusDialogState extends State<UpdateStatusDialog> {
  late TextEditingController notesController;
  late ReportStatus currentStatus;
  late List<ReportStatus> availableStatuses;
  late ReportStatus selectedStatus;
  bool isCheckingInProgressButton = false;

  @override
  void initState() {
    super.initState();
    notesController = TextEditingController();

    currentStatus = ReportStatus.values.firstWhere(
      (e) => e.name == widget.report.currentStatus,
      orElse: () => ReportStatus.Submitted,
    );

    availableStatuses = _getAvailableStatuses(currentStatus);
    selectedStatus =
        availableStatuses.isNotEmpty ? availableStatuses.first : currentStatus;
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
          Navigator.of(context)
              .pop((selectedStatus, notesController.text.trim()));
        } else if (state is ReportDetailError) {
          SnackBarHelper.show(context, state.message, type: SnackBarType.error);
        }
      },
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          constraints: const BoxConstraints(
            maxWidth: 450,
            minWidth: 340,
          ),
          child: AlertDialog(
            backgroundColor: Theme.of(context).dialogBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
            contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: currentStatus.color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(currentStatus.icon,
                          size: 16, color: currentStatus.color),
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
            content: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
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
                                Icon(status.icon,
                                    color: status.color, size: 18),
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
                    SizedBox(
                      height: 20,
                      child: selectedStatus != currentStatus
                          ? Row(
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
                            )
                          : const SizedBox(),
                    ),
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
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              BlocBuilder<ReportDetailCubit, ReportDetailState>(
                builder: (context, state) {
                  final isStatusUpdating = state.isStatusUpdating;
                  return SizedBox(
                    width: double.maxFinite,
                    height: 45,
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 45,
                            child: OutlinedButton(
                              onPressed: () => Navigator.of(context).pop(null),
                              style: OutlinedButton.styleFrom(
                                side:
                                    const BorderSide(color: AppColors.primary),
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'إلغاء',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SizedBox(
                            height: 45,
                            child: ElevatedButton(
                              onPressed: (isStatusUpdating ||
                                      isCheckingInProgressButton ||
                                      selectedStatus == currentStatus)
                                  ? null
                                  : () async {
                                      setState(() =>
                                          isCheckingInProgressButton = true);

                                      try {
                                        if (selectedStatus ==
                                            ReportStatus.In_Progress) {
                                          final reportsCubit =
                                              context.read<ReportsCubit>();
                                          final allReports =
                                              reportsCubit.allReports;
                                          final hasOtherInProgress =
                                              allReports.any(
                                            (r) =>
                                                r.currentStatus ==
                                                    ReportStatus
                                                        .In_Progress.name &&
                                                r.reportId !=
                                                    widget.report.reportId,
                                          );

                                          if (hasOtherInProgress) {
                                            SnackBarHelper.show(
                                              context,
                                              'لايمكن تحديث الحالة يوجد بلاغ جاري حاليا',
                                              type: SnackBarType.error,
                                            );
                                            return;
                                          }
                                        }

                                        Navigator.of(context).pop((
                                          selectedStatus,
                                          notesController.text.trim()
                                        ));
                                      } catch (e) {
                                        SnackBarHelper.show(
                                          context,
                                          'حدث خطأ أثناء تحديث الحالة',
                                          type: SnackBarType.error,
                                        );
                                      } finally {
                                        setState(() =>
                                            isCheckingInProgressButton = false);
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isStatusUpdating
                                    ? Colors.white
                                    : const Color(0xFF725DFE),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: (isStatusUpdating ||
                                      isCheckingInProgressButton)
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
                                        fontSize: 16,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<ReportStatus> _getAvailableStatuses(ReportStatus currentStatus) {
    final List<ReportStatus> available = [];

    switch (currentStatus) {
      case ReportStatus.Submitted:
        available.addAll([
          ReportStatus.In_Progress,
          ReportStatus.Cancelled,
        ]);
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
