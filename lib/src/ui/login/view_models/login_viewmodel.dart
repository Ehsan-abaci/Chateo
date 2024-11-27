import 'package:ehsan_chat/src/core/resources/result.dart';
import 'package:ehsan_chat/src/core/utils/locator.dart';
import 'package:ehsan_chat/src/data/repositories/auth_repository.dart';
import 'package:ehsan_chat/src/data/services/remote/auth_service.dart';
import 'package:ehsan_chat/src/model/login_request.dart';
import 'package:flutter/foundation.dart';

import '../../../core/resources/data_state.dart';

enum Status {
  initial,
  loading,
  success,
  error,
}

class LoginViewModel extends ChangeNotifier {
  final AuthRepository _auth = di<AuthRepository>();

  bool isAuthenticated = false;
  Status status = Status.initial;
  String? message;

  login(LoginRequest loginRequest) async {
    status = Status.loading;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 3));

    final result = await _auth.login(loginRequest);

    if (result is Ok) {
      status = Status.success;
      message = 'You logged in.';
    } else {
      status = Status.error;
      message = result.asError.error.message;
    }
    notifyListeners();
  }
}
