// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

enum ReportStatus {
  Submitted,
  In_Progress,
  On_Hold,
  Resolved,
  Cancelled,
}

extension ReportStatusExtension on ReportStatus {
  String get label {
    switch (this) {
      case ReportStatus.Submitted:
        return 'تم الاستلام';
      case ReportStatus.In_Progress:
        return 'قيد التنفيذ';
      case ReportStatus.On_Hold:
        return 'قيد الانتظار';
      case ReportStatus.Resolved:
        return 'تم الحل';
      case ReportStatus.Cancelled:
        return ' إلغاء';
    }
  }

  Color get color {
    switch (this) {
      case ReportStatus.Submitted:
        return Colors.blue;
      case ReportStatus.In_Progress:
        return Colors.orange;
      case ReportStatus.On_Hold:
        return Colors.amber;
      case ReportStatus.Resolved:
        return Colors.green;
      case ReportStatus.Cancelled:
        return Colors.red;
    }
  }

  IconData get icon {
    switch (this) {
      case ReportStatus.Submitted:
        return Icons.markunread;
      case ReportStatus.In_Progress:
        return Icons.timelapse;
      case ReportStatus.On_Hold:
        return Icons.pause_circle_filled;
      case ReportStatus.Resolved:
        return Icons.check_circle;
      case ReportStatus.Cancelled:
        return Icons.cancel;
    }
  }
}
