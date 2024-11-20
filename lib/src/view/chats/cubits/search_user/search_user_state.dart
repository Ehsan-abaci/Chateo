part of 'search_user_cubit.dart';

class SearchUserState extends Equatable {
  List<Conversation> users;

  SearchUserState({required this.users});

  @override
  List<Object> get props => [users];

  SearchUserState copyWith({
    List<Conversation>? users,
  }) {
    return SearchUserState(
      users: users ?? this.users,
    );
  }
}
