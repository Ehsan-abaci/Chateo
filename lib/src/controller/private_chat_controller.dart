import 'package:ehsan_chat/src/model/message.dart';
import 'package:ehsan_chat/src/repository/private_chat_repository.dart';

class PrivateChatController {
  static final PrivateChatController _instance =
      PrivateChatController._internal();
  factory PrivateChatController() => _instance;
  PrivateChatController._internal();

  String _chatId = '';
  String get chatId => _chatId;
  void setChatId(String chatId) => _chatId = chatId;

  Future<void> updateMessage(Message message) async =>
      await PrivateChatRepository().updateMessage(message);

  Future<void> newMessage(
    Map<String, dynamic> data,
  ) async =>
      await PrivateChatRepository().newMessage(data);
}
