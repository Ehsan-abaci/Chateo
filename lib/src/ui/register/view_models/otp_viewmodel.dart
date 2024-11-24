import 'package:flutter/foundation.dart';

import '../../../core/resources/result.dart';
import '../../../data/services/remote/auth_service.dart';
import '../../login/view_models/login_viewmodel.dart';

class OtpViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  Status status = Status.initial;
  String? message;

  verifyOtp({required String email, required String code}) async{
    status = Status.loading;
    notifyListeners();

    final result = await _authService.verifyOtpRequest(email, code);

    if (result is Ok) {
      status = Status.success;
    } else {
      status = Status.error;
      message = 'Otp verifying failed! ${result.asError.error}';
    }
  }
}
