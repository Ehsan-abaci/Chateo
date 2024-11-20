part of 'otp_bloc.dart';

@immutable
sealed class OtpEvent {}

class VerifyOtpRequestEvent extends OtpEvent {
  final String email;
  final String otp;
  VerifyOtpRequestEvent({
    required this.email,
    required this.otp,
  });
}
