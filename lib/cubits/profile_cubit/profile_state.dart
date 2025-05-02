part of 'profile_cubit.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String fullName;
  final String email;
  final String department;
  final String address;
  final double progress;
  final int solvedReports;
  final int totalReports;

  ProfileLoaded({
    required this.fullName,
    required this.email,
    required this.department,
    required this.address,
    required this.progress,
    required this.solvedReports,
    required this.totalReports,
  });
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}
