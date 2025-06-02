import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:civiceye/cubits/report_cubit/report_detail_state.dart';
import 'package:civiceye/models/report_model.dart';
import 'package:civiceye/models/report_status_enum.dart';
import 'package:civiceye/screens/map_screen.dart';
import 'package:civiceye/widgets/contact_section.dart';
import 'package:civiceye/widgets/show_update_status_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:civiceye/cubits/report_cubit/report_detail_cubit.dart';

class ReportDetailsScreen extends StatefulWidget {
  final ReportModel report;
  final String employeeId;

  const ReportDetailsScreen({
    super.key,
    required this.report,
    required this.employeeId,
  });

  @override
  State<ReportDetailsScreen> createState() => _ReportDetailsScreenState();
}

class _ReportDetailsScreenState extends State<ReportDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final status = ReportStatus.values.firstWhere(
      (e) => e.name == widget.report.currentStatus,
      orElse: () => ReportStatus.Submitted,
    );

    return BlocProvider(
      create: (context) => ReportDetailCubit(),
      child: Scaffold(
              appBar: AppBar(
              title: const Text(
                "تفاصيل البلاغ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              backgroundColor: const Color(0xFF725DFE),
              automaticallyImplyLeading: false, // يمنع السهم التلقائي
              actions: [
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
        body: BlocConsumer<ReportDetailCubit, ReportDetailState>(
          listener: (context, state) {
            if (state is ReportDetailError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildCard(
                        Icons.title,
                        "عنوان البلاغ",
                        widget.report.title,
                        isDarkMode,
                      ),
                      _buildCard(
                        Icons.location_on,
                        "الموقع",
                        "${widget.report.latitude}, ${widget.report.longitude}",
                        isDarkMode,
                        onTap: _openMap,
                      ),
                      _buildCard(
                        Icons.access_time,
                        "الوقت",
                        "${widget.report.createdAt.hour}:${widget.report.createdAt.minute.toString().padLeft(2, '0')}",
                        isDarkMode,
                      ),
                      _buildCard(
                        Icons.calendar_today,
                        "تاريخ البلاغ",
                        "${widget.report.createdAt.year}/${widget.report.createdAt.month}/${widget.report.createdAt.day}",
                        isDarkMode,
                      ),
                      _buildCard(
                        Icons.description,
                        "وصف البلاغ",
                        widget.report.description ?? 'لا يوجد وصف',
                        isDarkMode,
                      ),
                   _buildCard(
                        Icons.phone,
                        "معلومات الاتصال",
                        widget.report.contactInfo ?? 'لا توجد معلومات اتصال',
                        isDarkMode,
                        onTap: () {
                          final phone = widget.report.contactInfo;
                          if (phone != null && phone.trim().isNotEmpty) {
                            showDialog(
                              context: context,
                              builder: (ctx) =>
                                  CallConfirmationDialog(phone: phone),
                            );
                          }
                        },
                      ),
                      Card(
                        elevation: 3,
                        color: isDarkMode ? Colors.grey[800] : Colors.white,
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: Icon(
                            Icons.flag,
                            color: status.color,
                          ),
                          title: const Text(
                            'حالة البلاغ',
                            textAlign: TextAlign.right,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        subtitle: Text(
                            status.label,
                            style: TextStyle(
                              color: status.color,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    if (status != ReportStatus.Resolved &&
                          status != ReportStatus.Cancelled)
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              UpdateStatusDialog.show(
                                context: context,
                                report: widget.report,
                                employeeId: int.parse(widget.employeeId),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF725DFE),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 60, vertical: 25),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text(
                              "تحديث الحالة",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ),

                    ],
                  ),
                ),
                if (state is ReportDetailLoading)
                  const Center(child: CircularProgressIndicator()),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCard(
    IconData icon,
    String label,
    String? value,
    bool isDarkMode, {
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 3,
      color: isDarkMode ? Colors.grey[800] : Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Icon(icon, color: const Color(0xFF725DFE)),
        title: Text(
          label,
          textAlign: TextAlign.right,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        subtitle: Text(
          value ?? "غير متوفر",
          textAlign: TextAlign.right,
          style: TextStyle(
            color: isDarkMode ? Colors.white70 : Colors.black87,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  void _openMap() {
    final latitude = double.tryParse(widget.report.latitude.toString()) ?? 0.0;
    final longitude = double.tryParse(widget.report.longitude.toString()) ?? 0.0;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapScreen(
          latitude: latitude,
          longitude: longitude,
        ),
      ),
    );
  }
  Future<String> getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return "${place.street}, ${place.locality}, ${place.country}";
      } else {
        return "عنوان غير متاح";
      }
    } catch (e) {
      return "فشل في جلب العنوان";
    }
  }
}