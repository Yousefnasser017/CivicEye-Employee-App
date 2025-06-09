import 'package:civiceye/core/config/websocket.dart';
import 'package:civiceye/cubits/report_cubit/report_cubit.dart';
import 'package:civiceye/cubits/report_cubit/report_state.dart';
import 'package:civiceye/widgets/SnackbarHelper.dart';
import 'package:civiceye/widgets/info_card.dart';
import 'package:civiceye/widgets/loading_shimmer.dart';
import 'package:civiceye/widgets/report_status_card.dart';
import 'package:flutter/material.dart';
import 'package:civiceye/cubits/report_cubit/report_detail_cubit.dart';
import 'package:civiceye/cubits/report_cubit/report_detail_state.dart';
import 'package:civiceye/models/report_model.dart';
import 'package:civiceye/models/report_status_enum.dart';
import 'package:civiceye/screens/map_screen.dart';
import 'package:civiceye/widgets/contact_section.dart';
import 'package:civiceye/widgets/show_update_status_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportDetailsScreen extends StatefulWidget {
  final ReportModel report;
  final String employeeId;
  final int reportId;

  const ReportDetailsScreen({
    Key? key,
    required this.report,
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
    _currentReport = widget.report;

    reportsCubit = context.read<ReportsCubit>();
    reportDetailCubit = ReportDetailCubit(
      reportsCubit: reportsCubit,
      socketService: StompWebSocketService(),
    );

    reportDetailCubit.fetchReportDetails(widget.reportId);
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
        appBar: AppBar(
          title: const Text(
            "تفاصيل البلاغ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFF725DFE),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        body: BlocConsumer<ReportDetailCubit, ReportDetailState>(
          listener: (context, state) {
            if (state is ReportDetailLoaded) {
              setState(() {
                _currentReport = state.report;
                _isUpdatingStatus = false;
              });
            } else if (state is ReportDetailUpdating) {
              setState(() {
                _isUpdatingStatus = true;
              });
            } else if (state is ReportDetailUpdated) {
              setState(() {
                _currentReport = state.report;
                _isUpdatingStatus = false;
              });
             SnackBarHelper.show(context, 'تم تحديث الحالة بنجاح',
                  type: SnackBarType.success);
            } else if (state is ReportDetailError) {
              setState(() {
                _isUpdatingStatus = false;
              });
          SnackBarHelper.show(context, state.message,
                  type: SnackBarType.error);
            }
          },
          builder: (context, state) {
            if (state is ReportDetailLoading &&
                _currentReport == widget.report) {
              return ReportDetailsShimmer(isDarkMode: isDarkMode);
            }

            final displayReport = _currentReport;

            final status = ReportStatus.values.firstWhere(
              (e) => e.name == displayReport.currentStatus,
              orElse: () => ReportStatus.Submitted,
            );
            final timeString = formatTime(displayReport.createdAt);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
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
                  ReportStatusCard(
                    status: status,
                    isLoading: _isUpdatingStatus,
                  ),
                  const SizedBox(height: 20),
                  if (status != ReportStatus.Resolved &&
                      status != ReportStatus.Cancelled)
                    Center(
                      child: ElevatedButton(
                         onPressed: () async {
                          // ⭐️ احصل على الحالة الحالية لـ ReportsCubit
                          final currentReportsState =
                              context.read<ReportsCubit>().state;
                          if (currentReportsState is ReportsLoaded) {
                            // تحقق مما إذا كان هناك بلاغ In_Progress آخر غير البلاغ الحالي
                          }

                          final newStatus = await UpdateStatusDialog.show(
                            context: context,
                            report: displayReport,
                            employeeId: int.parse(widget.employeeId),
                            // ⭐️ تمرير هذه المعلومة الجديدة
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 20),
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
