import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ehsan_chat/src/core/resources/data_state.dart';
import 'package:ehsan_chat/src/core/resources/error_handler.dart';
import 'package:ehsan_chat/src/core/utils/app_prefs.dart';
import 'package:ehsan_chat/src/core/utils/constants.dart';
import 'package:ehsan_chat/src/model/login_request.dart';
import 'package:ehsan_chat/src/model/me.dart';
import 'package:ehsan_chat/src/model/signup_request.dart';

import '../../cache_manager/user_cache.dart';
import '../../core/utils/locator.dart';

class AuthDataSource {
  AuthDataSource._internal();
  static final AuthDataSource inst = AuthDataSource._internal();
  factory AuthDataSource() => inst;

  final Dio _dio = di<Dio>();

  static const String _prefix = "auth";

  String? get accessToken => AppPreferences().getAccessToken();

  Future<DataState> signupRequest(SignupRequest signupRequest) async {
    try {
      final response = await _dio.post(
        '${Constants.baseUrlV1}/$_prefix/sign-up',
        data: signupRequest.toMap(),
      );

      if (response.statusCode == HttpStatus.ok) {
        return DataSuccess(null, response.data['message']);
      } else {
        return DataFailed(response.data['message']);
      }
    } catch (e) {
      return ErrorHandler.handle(e).failure;
    }
  }

  Future<DataState> loginRequest(LoginRequest loginRequest) async {
    try {
      final response = await _dio.post(
        '${Constants.baseUrlV1}/$_prefix/login',
        data: loginRequest.toMap(),
      );
      if (response.statusCode == HttpStatus.ok) {
        final me = Me.fromMap(response.data);
        await UserCacheManager.save(
          email: me.email,
          token: me.token,
          userId: me.userId,
          username: me.username,
        );
        return DataSuccess(me, response.data['message']);
      } else {
        return DataFailed(response.data['message']);
      }
    } catch (e) {
      log(e.toString());
      return ErrorHandler.handle(e).failure;
    }
  }

  Future<DataState> verifyOtpRequest(String email, String otp) async {
    try {
      final response = await _dio.post(
        '${Constants.baseUrlV1}/$_prefix/verify-otp',
        data: {'email': email, 'otp': otp},
      );
      if (response.statusCode == HttpStatus.created) {
        final me = Me.fromMap(response.data);
        await UserCacheManager.save(
          email: me.email,
          token: me.token,
          userId: me.userId,
          username: me.username,
        );
        return DataSuccess(me, response.data['message']);
      } else {
        return DataFailed(response.data['message']);
      }
    } catch (e) {
      log(e.toString());
      return ErrorHandler.handle(e).failure;
    }
  }

  Future<void> logout() async {
    await UserCacheManager.clear();
  }
}
