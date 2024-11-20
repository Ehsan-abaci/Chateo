import 'package:ehsan_chat/src/model/message.dart';
import 'package:ehsan_chat/src/model/private.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract class Conversation {
  int? id;
  String? conversationName;
  String? conversationType;
  Message? lastMsg;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? roomImage;
  List<Message> msgList = [];
  int? lastIndex;
  int minViewPortSeenIndex = 0;
  int capacity = 50;

  bool verified = false;
  bool newRoomToGenerate = false;
  bool reachedToEnd = false;
  bool reachedToStart = false;
  bool firstOpenRoom = true;
  bool canScrollList = false;
  
  Conversation();

  Map<String, dynamic> toMap();

  String toJson();

  static Conversation createConversationByType(json) {
    switch (json['type']) {
      case 'private':
        return Private.fromMap(json);
      default:
        return Private.fromMap(json);
    }
  }

  static generateProfileImageByName(Conversation conv) =>
      _ConversationUtils.generateProfileImageByName(conv);
}

class _ConversationUtils {
  static Widget generateProfileImageByName(Conversation conv) {
    String name = conv.conversationName ?? 'guest';
    String family = '';
    try {
      if (name.contains(' ')) {
        family = ' ${name.split(' ')[1][0]}';
      }
    } catch (e) {
      if (kDebugMode) {
        print('generateProfileImageByName exception : $e');
      }
    }

    return Center(
      child: Text(
        name[0] + family,
        style: const TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }
}
