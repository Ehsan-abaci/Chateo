import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ehsan_chat/src/model/audio_message.dart';
import 'package:flutter/foundation.dart';

class DownloadService {
  Future downloadFile(String url, String savePath, chat) async {
    if (chat is AudioMessage) {
      try {
        Response response = await Dio().get(
          url,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              chat.downloadProgress = ValueNotifier(
                double.tryParse((received / total * 100).toStringAsFixed(2)),
              );
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
        File file = File(savePath);
        var raf = file.openSync(mode: FileMode.write);
        // response.data is List<int> type
        print('savePath is $savePath');
        raf.writeFromSync(response.data);
        await raf.close();
      } catch (e) {
        if (kDebugMode) {
          print('exception #002 $e');
        }
      }
    }
  }
}
