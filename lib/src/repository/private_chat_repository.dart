import 'dart:developer';

import 'package:ehsan_chat/main.dart';
import 'package:ehsan_chat/src/model/message.dart';

class PrivateChatRepository {
  static final PrivateChatRepository _instance =
      PrivateChatRepository._internal();
  factory PrivateChatRepository() => _instance;
  PrivateChatRepository._internal();

  int? chatId;

  Future<void> updateMessage(Message message) async {
    await supabase.from("messages").update({
      "content": message.content,
      "updated_at": DateTime.timestamp().toIso8601String(),
    }).eq("id", message.id);
  }

  Future<Map<String, dynamic>> newMessage(
    Map<String, dynamic> data,
  ) async {
    final receiverId = data['receiver'];
    final userId = data['user_id'];

    // Will create a new conversation if it does not exist between these two users  or return the active conversation ID
    if (chatId == null) {
      data['conversation_id'] = await _createNewConversation(
        userId,
        receiverId,
      );
      chatId = data['conversation_id'];
    } else {
      data['conversation_id'] = chatId;
    }

    // Create new chat message
    Map<String, dynamic> message = await _storeMessage(data);

    await _updateConversation(message['conversation_id'], message['id']);

    return message;
  }

// Return Active conversatyion Or Null
  Future<Map<String, dynamic>?> _getActiveConversation(
    int userId,
    int receiverId,
  ) async {
    final res = await supabase.rpc('get_active_conv', params: {
      'user_id': userId,
      'receiver_id': receiverId,
    });
    return (res as List<dynamic>).isEmpty
        ? null
        : res[0] as Map<String, dynamic>?;
  }

  // Create New Conversationn or return Active Conversation ID
  Future<int> _createNewConversation(
    int userId,
    int receiverId,
  ) async {
    // Will return the active conversation between these two users or null
    final conversation = await _getActiveConversation(
      userId,
      receiverId,
    );
    if (conversation == null) {
      final conversationId =
          await supabase.from("conversations").insert({}).select("id").single();

      await supabase.from("conversation_participants").insert([
        {
          "user_id": userId,
          "conversation_id": conversationId['id'],
        },
        {
          "user_id": receiverId,
          "conversation_id": conversationId['id'],
        }
      ]);
      return conversationId['id'];
    } else {
      return conversation['id'];
    }
  }

  Future<Map<String, dynamic>> _storeMessage(Map<String, dynamic> data) async {
    return await supabase
        .from("messages")
        .insert({
          "conversation_id": data['conversation_id'],
          "sender_id": data['user_id'],
          "content": data['content'],
        })
        .select()
        .single();
  }

  // Add last message id to the conversation
  Future<void> _updateConversation(int conversationId, int messageId) async {
    await supabase
        .from("conversations")
        .update(
          {"last_message_id": messageId},
        )
        .eq("id", conversationId)
        .select();
  }
}
