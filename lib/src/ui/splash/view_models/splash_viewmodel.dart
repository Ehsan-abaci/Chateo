import 'dart:developer';

import 'package:flutter/foundation.dart';

import '../../../cache_manager/user_cache.dart';
import '../../../core/utils/resources/config.dart';

class SplashViewModel extends ChangeNotifier {
  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  void init() async {
    try {
      _isAuthenticated = await UserCacheManager.checkLogin();

      if (isAuthenticated) {
        Config.me = UserCacheManager.getUserData();
      }
    } on Exception catch (_) {
      _isAuthenticated = false;
    } finally {
      notifyListeners();
    }
  }
}
