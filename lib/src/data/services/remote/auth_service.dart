
import 'package:ehsan_chat/src/core/utils/app_prefs.dart';
import '../../../cache_manager/user_cache.dart';

class AuthService {
  AuthService._internal();
  static final AuthService inst = AuthService._internal();
  factory AuthService() => inst;

  String? get accessToken => AppPreferences().getAccessToken();


  Future<void> logout() async {
    await UserCacheManager.clear();
  }
}
