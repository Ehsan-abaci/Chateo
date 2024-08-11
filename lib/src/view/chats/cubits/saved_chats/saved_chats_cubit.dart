import 'package:bloc/bloc.dart';
import 'package:ehsan_chat/src/controller/chats_controller.dart';
import 'package:equatable/equatable.dart';

import '../../../../model/user.dart';

part 'saved_chats_state.dart';

class SavedChatsCubit extends Cubit<SavedChatsState> {
  final ChatsController chatsController = ChatsController();
  SavedChatsCubit() : super(SavedChatsState(savedChats: const []));

  Future<void> saveChat(Users user) async {
    if (!state.savedChats.contains(user)) {
      await chatsController.saveChat(user);
      emit(state.copyWith(savedChats: [...state.savedChats, user]));
    }
  }

  Future<void> getChats() async {
    final users = await chatsController.getChats();
    emit(state.copyWith(savedChats: users));
  }
}
