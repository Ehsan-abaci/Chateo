part of 'login_bloc.dart';

class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  String message;
  LoginSuccess({
    required this.message,
  });
}

class LoginError extends LoginState {
  List<String> messages;
  LoginError({
    required this.messages,
  });
}
