import 'package:bloc/bloc.dart';
import 'package:ehsan_chat/src/core/resources/data_state.dart';
import 'package:ehsan_chat/src/data/remote/auth_date_source.dart';
import 'package:flutter/foundation.dart' show immutable;

import '../../../model/login_request.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthDataSource _auth = AuthDataSource();
  LoginBloc() : super(LoginInitial()) {
    on<LoginRequestEvent>((event, emit) async {
      emit(LoginLoading());
      final dataState = await _auth.loginRequest(event.loginRequest);

      if (dataState is DataSuccess) {
        emit(LoginSuccess(message: dataState.message!));
      } else {
        emit(LoginError(messages: dataState.error!));
      }
    });
  }
}
