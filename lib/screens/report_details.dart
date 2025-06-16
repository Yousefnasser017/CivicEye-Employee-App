// ignore_for_file: deprecated_member_use, unnecessary_null_comparison

import 'package:civiceye/animations/report_details_animation.dart';
import 'package:civiceye/core/config/websocket.dart';
import 'package:civiceye/cubits/report_cubit/report_cubit.dart';
import 'package:civiceye/cubits/report_cubit/report_state.dart';
import 'package:civiceye/widgets/SnackbarHelper.dart';
import 'package:civiceye/widgets/info_card.dart';
import 'package:civiceye/widgets/report_status_card.dart';
import 'package:flutter/material.dart';
import '../core/themes/app_colors.dart';
import 'package:civiceye/cubits/report_cubit/report_detail_cubit.dart';
import 'package:civiceye/cubits/report_cubit/report_detail_state.dart';
import 'package:civiceye/models/report_model.dart';
import 'package:civiceye/models/report_status_enum.dart';
import 'package:civiceye/screens/map_screen.dart';
import 'package:civiceye/widgets/contact_section.dart';
import 'package:civiceye/widgets/show_update_status_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportDetailsScreen extends StatefulWidget {
  final ReportModel? report;
  final String employeeId;
  final int reportId;

  const ReportDetailsScreen({
    Key? key,
    this.report,
    required this.employeeId,
    required this.reportId,
  }) : super(key: key);

  @override
  State<ReportDetailsScreen> createState() => _ReportDetailsScreenState();
}

class _ReportDetailsScreenState extends State<ReportDetailsScreen> {
  late final ReportsCubit reportsCubit;
  late final ReportDetailCubit reportDetailCubit;
  late ReportModel _currentReport;
  bool _isUpdatingStatus = false;

  @override
  void initState() {
    super.initState();
    reportsCubit = context.read<ReportsCubit>();
    reportDetailCubit = ReportDetailCubit(
      reportsCubit: reportsCubit,
      socketService: StompWebSocketService(),
    );
    if (widget.report != null) {
      _currentReport = widget.report!;
      // إذا كان report موجود لا داعي لجلب التفاصيل
    } else {
      // إذا لم يوجد report، جلب التفاصيل باستخدام reportId
      reportDetailCubit.fetchReportDetails(widget.reportId);
    }
  }

  @override
  void dispose() {
    reportDetailCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider.value(
      value: reportDetailCubit,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.92),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.07),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(22)),
            ),
            child: SafeArea(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    left: 16,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).maybePop(),
                      child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: AppColors.primary,
                            size: 24,
                            textDirection: TextDirection.ltr,
                          )),
                    ),
                  ),
                  const Center(
                    child: Text(
                      'تفاصيل البلاغ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 23,
                        color: Colors.white,
                        letterSpacing: 1.2,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            offset: Offset(0, 2),
                            blurRadius: 6,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: BlocConsumer<ReportDetailCubit, ReportDetailState>(
          listener: (context, state) {
            if (state is ReportDetailLoaded || state is ReportDetailUpdated) {
              if (state.report != null) {
                setState(() {
                  _currentReport = state.report!;
                  _isUpdatingStatus = false;
                });

                if (state is ReportDetailUpdated) {
                  // فقط نعرض رسالة النجاح
                  SnackBarHelper.show(context, 'تم تحديث الحالة بنجاح',
                      type: SnackBarType.success);
                }
              }
            } else if (state is ReportDetailError) {
              setState(() {
                _isUpdatingStatus = false;
              });
              SnackBarHelper.show(context, state.message,
                  type: SnackBarType.error);
            } else if (state is ReportDetailLoading) {
              setState(() {
                _isUpdatingStatus = true;
              });
            }
          },
          builder: (context, state) {
            if (state is ReportDetailLoading &&
                _currentReport == widget.report) {
              return ReportDetailsShimmer(isDarkMode: isDarkMode);
            }

            final displayReport = _currentReport;

            ReportStatus? status;
            try {
              status = ReportStatus.values.firstWhere(
                (e) => e.name == displayReport.currentStatus,
              );
            } catch (_) {
              status = null;
            }
            final timeString = formatTime(displayReport.createdAt);
            final screenWidth = MediaQuery.of(context).size.width;
            final screenHeight = MediaQuery.of(context).size.height;
            final paddingValue = screenWidth * 0.05;
            return SingleChildScrollView(
              padding: EdgeInsets.all(paddingValue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  InfoCard(
                    icon: Icons.title,
                    label: "عنوان البلاغ",
                    value: displayReport.title,
                    isDarkMode: isDarkMode,
                  ),
                  InfoCard(
                    icon: Icons.location_on,
                    label: "الموقع",
                    value: "موقع البلاغ على الخريطة",
                    isDarkMode: isDarkMode,
                    onTap: _openMap,
                    trailing: const Icon(Icons.map, color: Color(0xFF725DFE)),
                  ),
                  InfoCard(
                    icon: Icons.access_time,
                    label: "الوقت",
                    value: timeString,
                    isDarkMode: isDarkMode,
                  ),
                  InfoCard(
                    icon: Icons.calendar_today,
                    label: "تاريخ البلاغ",
                    value:
                        "${displayReport.createdAt.year}/${displayReport.createdAt.month}/${displayReport.createdAt.day}",
                    isDarkMode: isDarkMode,
                  ),
                  InfoCard(
                    icon: Icons.description,
                    label: "وصف البلاغ",
                    value: displayReport.description,
                    isDarkMode: isDarkMode,
                  ),
                  InfoCard(
                    icon: Icons.phone,
                    label: "معلومات الاتصال",
                    value: displayReport.contactInfo,
                    isDarkMode: isDarkMode,
                    onTap: () {
                      final phone = displayReport.contactInfo;
                      if (phone != null && phone.trim().isNotEmpty) {
                        showDialog(
                          context: context,
                          builder: (_) => CallConfirmationDialog(phone: phone),
                        );
                      }
                    },
                  ),
                  status != null
                      ? ReportStatusCard(
                          status: status,
                          isLoading: _isUpdatingStatus,
                        )
                      : const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'حالة البلاغ غير معروفة',
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                  const SizedBox(height: 20),
                  if (status != ReportStatus.Resolved &&
                      status != ReportStatus.Cancelled)
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          final currentReportsState =
                              context.read<ReportsCubit>().state;
                          if (currentReportsState is ReportsLoaded) {}

                          final newStatus = await UpdateStatusDialog.show(
                            context: context,
                            report: displayReport,
                            employeeId: int.parse(widget.employeeId),
                          );

                          if (newStatus != null &&
                              newStatus.toString().isNotEmpty) {
                            await context
                                .read<ReportDetailCubit>()
                                .updateReportStatus(
                                  displayReport,
                                  newStatus.name,
                                  displayReport.notes ?? '',
                                  int.parse(widget.employeeId),
                                );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF725DFE),
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.1,
                              vertical: screenHeight * 0.025),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "تحديث الحالة",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _openMap() {
    final latitude = double.tryParse(_currentReport.latitude.toString()) ?? 0.0;
    final longitude =
        double.tryParse(_currentReport.longitude.toString()) ?? 0.0;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            MapScreen(latitude: latitude, longitude: longitude),
      ),
    );
  }

  String formatTime(DateTime datetime) {
    final time = TimeOfDay.fromDateTime(datetime);
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'ص' : 'م';

    return '$hour:$minute $period';
  }
}
