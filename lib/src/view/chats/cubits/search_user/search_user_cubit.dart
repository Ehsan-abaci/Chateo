import 'package:bloc/bloc.dart';
import 'package:ehsan_chat/src/controller/chats_controller.dart';
import 'package:equatable/equatable.dart';

import '../../../../model/user.dart';

part 'search_user_state.dart';

class SearchUserCubit extends Cubit<SearchUserState> {
  SearchUserCubit() : super(SearchUserState(users: const []));

  searchUsersByUsername(String username) async {
    ChatsController.searchUserByUsername(username).then(
      (users) {
        emit(state.copyWith(users: users));
      },
    );
  }
}
