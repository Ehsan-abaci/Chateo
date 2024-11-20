// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:ehsan_chat/src/model/app_collection.dart';
import 'package:ehsan_chat/src/model/audio_message.dart';
import 'package:ehsan_chat/src/model/video_message.dart';

import '../core/utils/resources/config.dart';

part 'text_message.dart';
part 'photo_message.dart';

class Message implements AppCollection {
  int? id;
  int? conversationId;
  int? senderId;
  Message? replyTo;
  bool? seen;
  // String? type; // text, doc, photo, voice, sticker
  DateTime? createdAt;
  DateTime? updatedAt;

  Message(Map json) {
    id = json['id'];
    senderId = json['sender_id'];
    conversationId = json['conversation_id'];
    createdAt = DateTime.parse(json['created_at']);
    updatedAt = DateTime.parse(json['updated_at']);
    seen = json['seen'] ?? false;
    replyTo =
        json['reply_to'] == null ? null : detectMessageType(json['reply_to']);
  }

  bool isMyMessage() => Config.me!.userId == senderId;

  static Message detectMessageType(Map message) {
    switch (message['type']) {
      case 'text':
        return TextMessage(message);
      case 'image':
        return PhotoMessage(message);
      case 'audio':
        return AudioMessage(message);
      case 'video':
        return VideoMessage(message);
      // case 'sticker':
      //   return ChatStickerModel(message);
      // case 'voice':
      //   return ChatVoiceModel(message);
      // case 'doc':
      //   return ChatDocModel(message);
      default:
        return TextMessage(message);
    }
  }

  @override
  Map<String, dynamic> toSaveFormat() {
    return <String, dynamic>{
      'id': id,
      'sender_id': senderId,
      'conversation_id': conversationId,
      'reply_to': replyTo,
      'seen': seen,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  static Map? messageToMap(Message? message) {
    if (message == null) {
      return null;
    }
    Map saveFormat = message.toSaveFormat();
    saveFormat['reply_to'] = null;
    return saveFormat;
  }
}
