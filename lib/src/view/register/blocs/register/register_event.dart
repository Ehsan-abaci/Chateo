part of 'register_bloc.dart';

@immutable
sealed class RegisterEvent {}

class RegisterRequestEvent extends RegisterEvent {
  final SignupRequest signupRequest;
  RegisterRequestEvent({
    required this.signupRequest,
  });
}


