// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'register_bloc.dart';

class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  String message;
  RegisterSuccess({
    required this.message,
  });
}

class RegisterError extends RegisterState {
  List<String> messages;
  RegisterError({
    required this.messages,
  });
}
