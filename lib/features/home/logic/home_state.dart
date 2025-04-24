part of 'home_cubit.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final ReportModel? currentReport;
  final int totalReports;

  HomeLoaded({this.currentReport, required this.totalReports});
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
