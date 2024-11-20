import 'package:bloc/bloc.dart';
import 'package:ehsan_chat/src/core/resources/data_state.dart';
import 'package:ehsan_chat/src/data/remote/auth_date_source.dart';
import 'package:ehsan_chat/src/model/signup_request.dart';
import 'package:flutter/foundation.dart' show immutable;

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthDataSource _authController = AuthDataSource();
  RegisterBloc() : super(RegisterInitial()) {
    on<RegisterRequestEvent>((event, emit) async {
      emit(RegisterLoading());
      await Future.delayed(const Duration(seconds: 2));
      final dataState =
          await _authController.signupRequest(event.signupRequest);
      if (dataState is DataSuccess) {
        emit(RegisterSuccess(message: dataState.message!));
      } else {
        emit(RegisterError(messages: dataState.error!));
      }
    });
  }
}
