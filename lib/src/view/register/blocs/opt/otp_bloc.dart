import 'package:bloc/bloc.dart';
import 'package:ehsan_chat/src/cache_manager/user_cache.dart';
import 'package:ehsan_chat/src/data/remote/auth_date_source.dart';
import 'package:flutter/foundation.dart' show immutable;

import '../../../../core/resources/data_state.dart';
import '../../../../core/utils/app_prefs.dart';
import '../../../../core/utils/resources/config.dart';

part 'otp_event.dart';
part 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final AuthDataSource _authController = AuthDataSource();
  OtpBloc() : super(OtpInitial()) {
    on<VerifyOtpRequestEvent>((event, emit) async {
      emit(OtpLoading());
      final dataState =
          await _authController.verifyOtpRequest(event.email, event.otp);
      if (dataState is DataSuccess) {
        emit(OtpSuccess(message: dataState.message!));
        await AppPreferences().setLoggedIn();
        Config.me = UserCacheManager.getUserData();
      } else {
        emit(OtpError(messages: dataState.error!));
      }
    });
  }
}
