import 'package:ehsan_chat/src/core/utils/crypto_manager.dart';
import 'package:ehsan_chat/src/model/token.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../model/me.dart';

class UserCacheManager {
  UserCacheManager._();

  static const String USER_ID_KEY = '--user-id-key';
  static const String USER_NAME_KEY = '--user-name-key';
  static const String USER_EMAIL_KEY = '--user-email-key';
  static const String USER_TOKEN_KEY = '--user-token-key';

  static Me getUserData() {
    final box = Hive.box('me');
    try {
      return Me(
        email: box.get(USER_EMAIL_KEY),
        token: Token.fromJson(
            CryptoManager().decryptData(box.get(USER_TOKEN_KEY))!),
        userId: box.get(USER_ID_KEY),
        username: box.get(USER_NAME_KEY),
      );
    } catch (e) {
      throw Exception('User is unauthorized');
    }
  }

  static Future<void> save({
    required String email,
    required Token token,
    required int userId,
    required String username,
  }) async {
    final box = Hive.box('me');
    final encryptedToken = CryptoManager().encryptData(token.toJson());
    await box.put(USER_ID_KEY, userId);
    await box.put(USER_EMAIL_KEY, email);
    await box.put(USER_NAME_KEY, username);
    await box.put(USER_TOKEN_KEY, encryptedToken);
  }

  static Future<void> clear() async {
    final box = Hive.box('me');
    await box.clear();
  }

  static Future<bool> checkLogin() async {
    final box = Hive.box('me');
    try {
      final userId = await box.get(USER_ID_KEY);
      return userId != null;
    } catch (e) {
      throw Exception('User logged out');
    }
  }
}
