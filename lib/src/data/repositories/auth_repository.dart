import 'dart:developer';

import '../../cache_manager/user_cache.dart';
import '../../core/resources/api_client.dart';
import '../../core/resources/error_handler.dart';
import '../../core/resources/result.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/locator.dart';
import '../../model/login_request.dart';
import '../../model/me.dart';
import '../../model/signup_request.dart';

class AuthRepository {
  final ApiClient _apiClient = di();

  static const String _prefix = "auth";
  Future<Result<void>> signup(SignupRequest signupRequest) async {
    try {
      await _apiClient.makePostRequest(
        endpoint: '${Constants.baseUrlV1}/$_prefix/sign-up',
        data: signupRequest.toMap(),
        parser: (_) {},
      );
      return const Result.ok(null);
    } on NetworkException catch (error) {
      return Result.error(error);
    } catch (e) {
      return Result.error(AppException(message: 'Unexpected error occured'));
    }
  }

  Future<Result<Me>> login(LoginRequest loginRequest) async {
    try {
      final data = await _apiClient.makePostRequest<Me>(
        endpoint: '${Constants.baseUrlV1}/$_prefix/login',
        data: loginRequest.toMap(),
        parser: (json) => Me.fromMap(json),
      );
      await UserCacheManager.save(
        email: data.email,
        token: data.token,
        userId: data.userId,
        username: data.username,
      );
      return Result.ok(data);
    } on NetworkException catch (error) {
      return Result.error(error);
    } catch (e) {
      return Result.error(
        AppException(message: 'Unexpected error occured'),
      );
    }
  }

  Future<Result<Me>> verifyOtpRequest(String email, String otp) async {
    try {
      final data = await _apiClient.makePostRequest<Me>(
        endpoint: '${Constants.baseUrlV1}/$_prefix/verify-otp',
        data: {'email': email, 'otp': otp},
        parser: (json) => Me.fromMap(json),
      );
      await UserCacheManager.save(
        email: data.email,
        token: data.token,
        userId: data.userId,
        username: data.username,
      );
      return Result.ok(data);
    } on NetworkException catch (e) {
      return Result.error(e);
    } catch (e) {
      return Result.error(AppException(message: 'Unexpected error occured'));
    }
  }
}
