part of 'profile_cubit.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {
  
}

class ProfileLoaded extends ProfileState {
  final String fullName;
  final String email;
  final String department;
  final String address;


  ProfileLoaded({
    required this.fullName,
    required this.email,
    required this.department,
    required this.address,

  });
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}
