import 'dart:convert';
import 'package:ehsan_chat/src/model/conversation.dart';
import 'package:ehsan_chat/src/model/user.dart';

import 'message.dart';

class Private extends Conversation {
  User? user;
  Private();

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': 'private',
      'user': user?.toMap(),
      'last_msg': lastMsg?.toSaveFormat(),
      'last_index': lastIndex,
      'minViewPortSeenIndex': minViewPortSeenIndex,
      'messages': msgList.map((e) => e.toSaveFormat()).toList(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory Private.fromMap(Map<String, dynamic> map) {
    final conv = Private()
      ..id = map['id']
      ..conversationType = 'private'
      ..user = User.fromMap(map['user'])
      ..createdAt =
          map['created_at'] != null ? DateTime.parse(map['created_at']) : null
      ..updatedAt =
          map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null
      ..msgList = map['messages'] != null
          ? List<Message>.from(
              map['messages'].map((msg) => Message.detectMessageType(msg)))
          : []
      ..minViewPortSeenIndex = map['minViewPortSeenIndex'] ?? 0
      ..lastIndex = map['last_index'] as int?
      ..lastMsg = map['last_msg'] != null
          ? Message.detectMessageType(map['last_msg'])
          : null
      ..roomImage = map['user']['avatar'];

    conv.conversationName = conv.user?.firstname ?? conv.user?.username;

    return conv;
  }

  @override
  String toJson() => json.encode(toMap);

  factory Private.fromJson(String source) =>
      Private.fromMap(json.decode(source) as Map<String, dynamic>);
}
