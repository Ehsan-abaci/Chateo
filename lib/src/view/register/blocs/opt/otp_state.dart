part of 'otp_bloc.dart';

@immutable
sealed class OtpState {}

final class OtpInitial extends OtpState {}

class OtpLoading extends OtpState {}

class OtpSuccess extends OtpState {
  String message;
  OtpSuccess({
    required this.message,
  });
}

class OtpError extends OtpState {
  List<String> messages;
  OtpError({
    required this.messages,
  });
}