abstract class ReportDetailsState {}

class ReportDetailsInitial extends ReportDetailsState {}

class ReportDetailsLoading extends ReportDetailsState {}

class ReportDetailsStatusUpdated extends ReportDetailsState {
  final String message;
  ReportDetailsStatusUpdated(this.message);
}

class ReportDetailsError extends ReportDetailsState {
  final String message;
  ReportDetailsError(this.message);
}
