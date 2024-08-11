// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'saved_chats_cubit.dart';

class SavedChatsState extends Equatable {
  List<Users> savedChats;
  SavedChatsState({required this.savedChats});
  @override
  List<Object> get props => [savedChats];

  SavedChatsState copyWith({
    List<Users>? savedChats,
  }) {
    return SavedChatsState(
      savedChats: savedChats ?? this.savedChats,
    );
  }
}
