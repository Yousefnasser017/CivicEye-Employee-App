enum ReportStatus {
  submitted,
  inProgress,
  onHold,
  resolved,
  closed,
}

extension ReportStatusExtension on ReportStatus {
  String get name {
    switch (this) {
      case ReportStatus.submitted:
        return 'Submitted';
      case ReportStatus.inProgress:
        return 'In Progress';
      case ReportStatus.onHold:
        return 'On Hold';
      case ReportStatus.resolved:
        return 'Resolved';
      case ReportStatus.closed:
        return 'Closed';
    }
  }

  static ReportStatus? fromString(String value) {
    switch (value.toLowerCase()) {
      case 'submitted':
        return ReportStatus.submitted;
      case 'in progress':
        return ReportStatus.inProgress;
      case 'on hold':
        return ReportStatus.onHold;
      case 'resolved':
        return ReportStatus.resolved;
      case 'closed':
        return ReportStatus.closed;
      default:
        return null;
    }
  }
}
