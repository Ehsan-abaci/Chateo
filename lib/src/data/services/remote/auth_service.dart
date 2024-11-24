import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ehsan_chat/src/core/resources/data_state.dart';
import 'package:ehsan_chat/src/core/resources/error_handler.dart';
import 'package:ehsan_chat/src/core/resources/result.dart';
import 'package:ehsan_chat/src/core/utils/app_prefs.dart';
import 'package:ehsan_chat/src/core/utils/constants.dart';
import 'package:ehsan_chat/src/model/login_request.dart';
import 'package:ehsan_chat/src/model/me.dart';
import 'package:ehsan_chat/src/model/signup_request.dart';

import '../../../cache_manager/user_cache.dart';
import '../../../core/utils/locator.dart';

class AuthService {
  AuthService._internal();
  static final AuthService inst = AuthService._internal();
  factory AuthService() => inst;

  final Dio _dio = di<Dio>();

  static const String _prefix = "auth";

  String? get accessToken => AppPreferences().getAccessToken();

  Future<Result<void>> signupRequest(SignupRequest signupRequest) async {
    try {
      final response = await _dio.post(
        '${Constants.baseUrlV1}/$_prefix/sign-up',
        data: signupRequest.toMap(),
      );

      if (response.statusCode == HttpStatus.ok) {
        return Result.ok(null);
      } else {
        log(response.data['message']);
        return Result.error(response.data['message']);
      }
    } on DioException catch (error) {
      switch (error.response?.statusCode) {
        case 422:
          final msg = (error.response?.data as Map).values.join('\n');
          return Result.error(msg);
        default:
          return Result.error('Register failed!');
      }
    }
  }

  Future<Result<Me>> loginRequest(LoginRequest loginRequest) async {
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
        return Result.ok(me);
      } else {
        return Result.error(response.data['message']);
      }
    } on DioException catch (error) {
      switch (error.response?.statusCode) {
        case 422:
          final msg = (error.response?.data as Map).values.join('\n');
          return Result.error(msg);
        default:
          return Result.error('Login failed!');
      }
    }
  }

  Future<Result<Me>> verifyOtpRequest(String email, String otp) async {
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
        return Result.ok(me);
      } else {
        return Result.error(response.data['message']);
      }
    } on Exception catch (_) {
      return Result.error('error');
    }
  }

  Future<void> logout() async {
    await UserCacheManager.clear();
  }
}
