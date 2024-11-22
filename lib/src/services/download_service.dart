import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ehsan_chat/src/model/video_message.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'package:ehsan_chat/src/model/audio_message.dart';

import '../core/utils/constants.dart';

class DownloadService {
  Future downloadFile(String url, chat) async {
    Directory? appDirectory = await _createAppDirectoryToCache();

    if (chat is AudioMessage || chat is VideoMessage) {
      try {
        File file = _createFileWith(url, appDirectory);
        _checkIfFileExists(file);

        Response response = await Dio().get(
          '${Constants.serverUrl}$url',
          onReceiveProgress: (received, total) {
            if (total != -1) {
              chat.downloadProgress.value =
                  double.tryParse((received / total).toStringAsFixed(2));
            }
          },
          //Received data with List<int>
          options: Options(
              responseType: ResponseType.bytes,
              followRedirects: false,
              validateStatus: (status) {
                return status! == 200;
              }),
        );

        var raf = file.openSync(mode: FileMode.write);
        // response.data is List<int> type
        print('savePath is ${raf.path}');
        raf.writeFromSync(response.data);
        await raf.close();
      } catch (e) {
        if (kDebugMode) {
          print('exception #002 $e');
        }
      }
    }
  }

  File _createFileWith(String url, Directory appDirectory) {
    final fileName = url.split('/').last;
    File file = File(path.join(appDirectory.path, fileName));
    return file;
  }

  static Future<Directory> _createAppDirectoryToCache() async {
    Directory? appDirectory = await getApplicationCacheDirectory();
    await appDirectory.create(recursive: true);
    return appDirectory;
  }

  static Future<Directory> _createAppDirectoryToSave() async {
    Directory? appDirectory = await getDownloadsDirectory();
    if (appDirectory != null) {
      appDirectory = await getApplicationDocumentsDirectory();
    }
    final chateoDir = Directory(path.join(appDirectory!.path, 'Chateo'));
    await chateoDir.create(recursive: true);
    return chateoDir;
  }

  static void _checkIfFileExists(File file) {
    if (file.existsSync()) {
      throw Exception('file already exists');
    }
  }

  /// This method checks if there is file with [url] and returns a path.
  Stream<String?> checkIfFileCachedWith(String url) async* {
    final appDirectory = await _createAppDirectoryToCache();
    final file = _createFileWith(url, appDirectory);

    bool? lastState;
    while (true) {
      final exists = file.existsSync();
      if (lastState != exists) {
        lastState = exists;
      }
      yield exists ? file.path : null; // Emit only when the state changes
      await Future.delayed(
        const Duration(seconds: 1),
      ); // Adjust the polling interval as needed
    }
  }
}
