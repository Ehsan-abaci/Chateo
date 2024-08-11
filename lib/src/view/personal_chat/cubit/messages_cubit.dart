import 'package:bloc/bloc.dart';
import 'package:ehsan_chat/main.dart';
import 'package:ehsan_chat/src/view/navbar/screen_navbar.dart';
import 'package:equatable/equatable.dart';

import '../../../model/message.dart';

part 'messages_state.dart';

class MessagesCubit extends Cubit<MessagesState> {
  MessagesCubit() : super(MessagesState(messages: []));

  Future<void> initialMessages() async {
    final snap = await supabase
        .from('messages')
        .select("*")
        .eq('conversation_id', 1)
        .order('created_at')
        .withConverter((data) => data
            .map((data) => Message.fromJson(map: data, myUserId: myUserId))
            .toList());
    emit(state.copyWith(messages: snap));
  }

  addMessage(Message messages) {
    emit(state.copyWith(messages: [ messages,...state.messages]));
  }
  updateMessage(Message message) {
    emit(state.copyWith(messages: state.messages
        .map((e) => e.id == message.id ? message : e)
        .toList()));
  }
}
