import 'package:ehsan_chat/src/core/resources/data_state.dart';
import 'package:ehsan_chat/src/core/utils/locator.dart';
import 'package:ehsan_chat/src/core/utils/resources/config.dart';
import 'package:ehsan_chat/src/data/remote/upload_media_data_source.dart';
import 'package:ehsan_chat/src/model/media_file.dart';
import 'package:ehsan_chat/src/providers/chat_provider.dart';
import 'package:flutter/material.dart';


class PersonalChatProvider extends ChangeNotifier {
  ChatProvider? _chatProvider;
  final TextEditingController messageController = TextEditingController();
  MediaFile? mediafile;

  initChatProvider(ChatProvider cp) {
    _chatProvider = cp;
  }

  Future sendNewMessageTo(int id) async {
    if (mediafile != null) {
      await _sendNewMediaMessageTo(id, mediafile!);
      clearMediaFile();
    } else {
      _sendNewTextMessageTo(id);
    }
  }

  _sendNewTextMessageTo(int id) {
    if (messageController.text.isNotEmpty) {
      _chatProvider?.send(
        event: 'new-message',
        payload: {
          'user_id': Config.me?.userId,
          'reciever_id': id,
          'content': messageController.text.trim(),
          'type': 'text',
        },
      );
      messageController.clear();
    }
  }

  Future _sendNewMediaMessageTo(int id, MediaFile media) async {
    final dataState = await UploadMediaDataSource(di()).uploadMedia(media);

    if (dataState is DataSuccess) {
      _chatProvider?.send(
        event: 'new-message',
        payload: {
          'user_id': Config.me?.userId,
          'reciever_id': id,
          'content': messageController.text.trim(),
          'media': dataState.data['path'],
          'type': dataState.data['type'],
        },
      );
    }
    messageController.clear();
  }

  setMediaFile(MediaFile file) {
    mediafile = file;
    notifyListeners();
  }

  clearMediaFile() {
    mediafile = null;
    notifyListeners();
  }
}
