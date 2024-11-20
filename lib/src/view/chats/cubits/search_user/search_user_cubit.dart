import 'package:bloc/bloc.dart';
import 'package:ehsan_chat/src/data/remote/search_user_data_source.dart';
import 'package:ehsan_chat/src/model/conversation.dart';
import 'package:equatable/equatable.dart';


part 'search_user_state.dart';

class SearchUserCubit extends Cubit<SearchUserState> {
  final SearchUserDataSource _searchUserDataSource;
  SearchUserCubit(this._searchUserDataSource)
      : super(SearchUserState(users: const []));

  searchUsersByUsername(String username) async {
    if (username.isEmpty) {
      emit(state.copyWith(users: []));
      return;
    }
    if (!username.startsWith('@')) username = "@$username";
    final dataState =
        await _searchUserDataSource.searchUsersByUsername(username);

    emit(state.copyWith(users: dataState.data ?? []));
  }
}
