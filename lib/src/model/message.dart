// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Message {
  int id;
  int conversationId;
  int senderId;
  String content;
  bool isMine;
  DateTime createdAt;
  DateTime updatedAt;
  Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.content,
    required this.isMine,
    required this.createdAt,
    required this.updatedAt,
  });

  Message.fromJson({
    required Map<String, dynamic> map,
    required int myUserId,
  })  : id = map['id'],
        senderId = map['sender_id'],
        conversationId = map['conversation_id'],
        content = map['content'],
        createdAt = DateTime.parse(map['created_at']),
        updatedAt = DateTime.parse(map['updated_at']),
        isMine = myUserId == map['sender_id'];

  @override
  String toString() {
    return 'Message(id: $id, conversationId: $conversationId, senderId: $senderId, content: $content, isMine: $isMine, createdAt: $createdAt ,updatedAt: $updatedAt)';
  }

  Message copyWith({
    int? id,
    int? conversationId,
    int? senderId,
    String? content,
    bool? isMine,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Message(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      isMine: isMine ?? this.isMine,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
