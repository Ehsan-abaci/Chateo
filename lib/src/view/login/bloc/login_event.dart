part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

class LoginRequestEvent extends LoginEvent {
  final LoginRequest loginRequest;
  LoginRequestEvent({
    required this.loginRequest,
  });
}
