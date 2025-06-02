import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginFailure extends LoginState {
  final String message;
  LoginFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class LogoutInProgress extends LoginState {}

class LogoutSuccess extends LoginState {}

class LogoutFailure extends LoginState {
  final String errorMessage;
  LogoutFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class LoginPasswordVisibilityChanged extends LoginState {
  final bool isPasswordVisible;

  LoginPasswordVisibilityChanged(this.isPasswordVisible);

  @override
  List<Object?> get props => [isPasswordVisible];
}
