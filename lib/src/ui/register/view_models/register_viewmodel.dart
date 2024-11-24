import 'package:ehsan_chat/src/core/resources/result.dart';
import 'package:ehsan_chat/src/data/services/remote/auth_service.dart';
import 'package:ehsan_chat/src/model/signup_request.dart';
import 'package:flutter/foundation.dart';

import '../../login/view_models/login_viewmodel.dart';

class RegisterViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  Status status = Status.initial;
  String? message;

  register(SignupRequest signupRequest) async {
    status = Status.loading;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));
    final result = await _authService.signupRequest(signupRequest);
    if (result is Ok) {
      status = Status.success;
    } else {
      status = Status.error;
      message = result.asError.error;
    }
    notifyListeners();
  }
}
