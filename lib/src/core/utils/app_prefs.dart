import 'package:ehsan_chat/src/core/utils/resources/config.dart';
import 'package:hive/hive.dart';

const String PREFS_KEY_LANG = 'PREFS_KEY_LANG';
const String PREFS_KEY_ONBOARDING_SCREEN = 'PREFS_KEY_ONBOARDING_SCREEN';
const String PREFS_KEY_IS_LOGGED_IN = 'PREFS_KEY_IS_LOGGED_IN';

class AppPreferences {
  AppPreferences._internal();
  static final AppPreferences _singleton = AppPreferences._internal();
  factory AppPreferences() => _singleton;

  final me = Hive.box('me');

  Future<void> setLoggedIn() async {
    await me.put(PREFS_KEY_IS_LOGGED_IN, true);
  }

  String? getAccessToken() {
    return Config.me?.token.accessToken;
  }

  Future<bool> isLoggedIn() async {
    final isLogged = me.get(PREFS_KEY_IS_LOGGED_IN) ?? false;
    return isLogged;
  }

  Future<void> logout() async {
    await me.clear();
  }
}
