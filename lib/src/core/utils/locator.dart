import 'dart:io';
import 'package:dio/dio.dart';
import 'package:ehsan_chat/src/core/resources/api_client.dart';
import 'package:ehsan_chat/src/data/repositories/auth_repository.dart';
import 'package:ehsan_chat/src/data/services/remote/user_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';

import 'constants.dart';

var di = GetIt.instance;

Future<void> initAppModule() async {
  Dio dio = Dio(
    BaseOptions(
      baseUrl: Constants.baseUrlV1,
      validateStatus: (statusCode) {
        if (statusCode == null) {
          return false;
        }
        if (statusCode == 422) {
          // your http status code
          return true;
        } else {
          return statusCode >= 200 && statusCode < 300;
        }
      },
    ),
  );
  di.registerLazySingleton(() => ApiClient(dio));

  // Hive data base
  Hive.init('./');
  if (!kIsWeb) {
    if (Platform.isAndroid || Platform.isIOS) {
      await Hive.initFlutter();
    }
  }

  await Hive.openBox<Map>('user');
  await Hive.openBox<String>('conversation');
  await Hive.openBox<Map>('chat');
  await Hive.openBox('me');
  await Hive.openBox('setting');

  /// remote data sources
  di.registerLazySingleton(() => UserService());

  // Repositories
  di.registerLazySingleton(() => AuthRepository());
}
