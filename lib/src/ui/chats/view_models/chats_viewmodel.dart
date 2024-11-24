import 'package:ehsan_chat/src/data/services/remote/search_user_service.dart';
import 'package:flutter/foundation.dart';

import '../../../model/conversation.dart';

class ChatsViewModel extends ChangeNotifier {
  final SearchUserService searchUserService;
  ChatsViewModel(this.searchUserService);

  List<Conversation> serchedUsers = [];

  searchUsersByUsername(String username) async {
    if (username.isEmpty) {
      serchedUsers = [];
      notifyListeners();
      return;
    }
    if (!username.startsWith('@')) username = "@$username";
    final dataState = await searchUserService.searchUsersByUsername(username);
    serchedUsers = dataState.data ?? [];
    notifyListeners();
  }
}
