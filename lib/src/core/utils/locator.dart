import 'dart:io';
import 'package:ehsan_chat/src/core/resources/api_client.dart';
import 'package:ehsan_chat/src/data/services/remote/search_user_service.dart';
import 'package:ehsan_chat/src/providers/audio_provider.dart';
import 'package:ehsan_chat/src/providers/chat_provider.dart';
import 'package:ehsan_chat/src/providers/home_provider.dart';
import 'package:ehsan_chat/src/providers/video_provider.dart';
import 'package:ehsan_chat/src/ui/splash/view_models/splash_viewmodel.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';

var di = GetIt.instance;

Future<void> initAppModule() async {
  di.registerLazySingleton(() => ApiClient.getDio());
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
  di.registerLazySingleton(() => SearchUserService(di()));

}
