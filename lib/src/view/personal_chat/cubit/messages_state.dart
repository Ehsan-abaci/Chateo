// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'messages_cubit.dart';

class MessagesState extends Equatable {
  List<Message> messages;

  MessagesState({required this.messages});
  @override
  List<Object> get props => [messages];

  MessagesState copyWith({
    List<Message>? messages,
  }) {
    return MessagesState(
      messages: messages ?? this.messages,
    );
  }
}
