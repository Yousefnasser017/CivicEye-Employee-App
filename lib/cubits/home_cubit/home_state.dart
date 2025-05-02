// home_state.dart
part of 'home_cubit.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final int pendingCount;
  final int resolvedCount;
  final int todayCount;
  final ReportModel? currentReport;

  HomeLoaded({
    required this.pendingCount,
    required this.resolvedCount,
    required this.todayCount,
    required this.currentReport,
  });
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}