import 'package:ehsan_chat/src/model/message.dart';
import 'package:flutter/foundation.dart' show ValueNotifier;

class AudioMessage extends Message {
  ValueNotifier<double?>? downloadProgress;
  String? fileUrl;
  String? text;
  AudioMessage(Map json) : super(json) {
    if (json.containsKey('media')) {
      fileUrl = json['media'];
    }
    text = json['content'];
  }

  @override
  Map<String, dynamic> toSaveFormat() {
    Map<String, dynamic> chatSaveFormat = super.toSaveFormat();
    chatSaveFormat['media'] = fileUrl;
    chatSaveFormat['content'] = text;
    chatSaveFormat['type'] = 'audio';
    return chatSaveFormat;
  }
}
