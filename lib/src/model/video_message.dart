import 'package:ehsan_chat/src/model/message.dart';
import 'package:flutter/material.dart' show ValueNotifier;

class VideoMessage extends Message {
  ValueNotifier<double> downloadProgress = ValueNotifier(1);
  String? fileUrl;
  String? text;

  VideoMessage(
    Map json,
  ) : super(json) {
    fileUrl = json['media'];
    text = json['content'];
  }

  @override
  Map<String, dynamic> toSaveFormat() {
    Map<String, dynamic> chatSaveFormat = super.toSaveFormat();
    chatSaveFormat['media'] = fileUrl;
    chatSaveFormat['content'] = text;
    chatSaveFormat['type'] = 'video';
    return chatSaveFormat;
  }
}
