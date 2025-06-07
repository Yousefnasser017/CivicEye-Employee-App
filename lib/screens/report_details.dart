import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
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

  const ReportDetailsScreen({
    Key? key,
    required this.report,
    required this.employeeId,
  }) : super(key: key);

  @override
  State<ReportDetailsScreen> createState() => _ReportDetailsScreenState();
}

class _ReportDetailsScreenState extends State<ReportDetailsScreen> {
  late ReportStatus status;
  late String timeString;

  @override
  void initState() {
    super.initState();
    status = ReportStatus.values.firstWhere(
      (e) => e.name == widget.report.currentStatus,
      orElse: () => ReportStatus.Submitted,
    );

    final time = TimeOfDay.fromDateTime(widget.report.createdAt);
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? "ص" : "م";
    timeString = "$hour:$minute $period";
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
            if (state is ReportDetailUpdated) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('✅ تم تحديث الحالة بنجاح')),
              );
              setState(() {
                status = ReportStatus.values.firstWhere(
                  (e) => e.name == widget.report.currentStatus,
                  orElse: () => ReportStatus.Submitted,
                );
              });
            } else if (state is ReportDetailError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('خطأ: ${state.message}')),
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
                        icon: Icons.title,
                        label: "عنوان البلاغ",
                        value: widget.report.title,
                        isDarkMode: isDarkMode,
                      ),
                      _buildCard(
                        icon: Icons.location_on,
                        label: "الموقع",
                        value: "موقع البلاغ على الخريطة",
                        isDarkMode: isDarkMode,
                        onTap: _openMap,
                        trailing:
                            const Icon(Icons.map, color: Color(0xFF725DFE)),
                      ),
                      _buildCard(
                        icon: Icons.access_time,
                        label: "الوقت",
                        value: timeString,
                        isDarkMode: isDarkMode,
                      ),
                      _buildCard(
                        icon: Icons.calendar_today,
                        label: "تاريخ البلاغ",
                        value:
                            "${widget.report.createdAt.year}/${widget.report.createdAt.month}/${widget.report.createdAt.day}",
                        isDarkMode: isDarkMode,
                      ),
                      _buildCard(
                        icon: Icons.description,
                        label: "وصف البلاغ",
                        value: widget.report.description,
                        isDarkMode: isDarkMode,
                      ),
                      _buildCard(
                        icon: Icons.phone,
                        label: "معلومات الاتصال",
                        value: widget.report.contactInfo,
                        isDarkMode: isDarkMode,
                        onTap: () {
                          final phone = widget.report.contactInfo;
                          if (phone != null && phone.trim().isNotEmpty) {
                            showDialog(
                              context: context,
                              builder: (_) =>
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
                          leading: Icon(Icons.flag, color: status.color),
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
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF725DFE),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 20),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text(
                              "تحديث الحالة",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
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

  Widget _buildCard({
    required IconData icon,
    required String label,
    String? value,
    required bool isDarkMode,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return Card(
      elevation: 3,
      color: isDarkMode ? Colors.grey[800] : Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Icon(icon, color: const Color(0xFF725DFE)),
        title: Text(
          label,
          textAlign: TextAlign.right,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        subtitle: Text(
          value ?? "غير متوفر",
          textAlign: TextAlign.right,
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black87,
            fontSize: 16,
          ),
        ),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }

  void _openMap() {
    final latitude = double.tryParse(widget.report.latitude.toString()) ?? 0.0;
    final longitude =
        double.tryParse(widget.report.longitude.toString()) ?? 0.0;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            MapScreen(latitude: latitude, longitude: longitude),
      ),
    );
  }

  Future<String> getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return "${place.street}, ${place.locality}, ${place.country}";
      }
      return "عنوان غير متاح";
    } catch (_) {
      return "فشل في جلب العنوان";
    }
  }
}
