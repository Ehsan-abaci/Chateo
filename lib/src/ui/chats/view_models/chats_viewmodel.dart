import 'package:ehsan_chat/src/core/resources/result.dart';
import 'package:ehsan_chat/src/data/services/remote/user_service.dart';
import 'package:flutter/foundation.dart';

import '../../../model/conversation.dart';

class ChatsViewModel extends ChangeNotifier {
  final UserService searchUserService;
  ChatsViewModel(this.searchUserService);

  List<Conversation> serchedUsers = [];

  searchUsersByUsername(String username) async {
    if (username.isEmpty) {
      serchedUsers = [];
      notifyListeners();
      return;
    }
    if (!username.startsWith('@')) username = "@$username";
    final result = await searchUserService.searchUsersByUsername(username);
    if (result is Ok) {
      serchedUsers = result.asOk.value;
    }
    notifyListeners();
  }
}
