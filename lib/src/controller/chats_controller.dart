import 'package:ehsan_chat/main.dart';
import 'package:ehsan_chat/src/core/utils/locator.dart';
import 'package:isar/isar.dart';

import '../model/user.dart';

class ChatsController {
  final isar = di<Isar>();

  static Future<List<Users>> searchUserByUsername(String username) async {
    return await supabase
        .schema("public")
        .from("profiles")
        .select("id, avatar, username,fullname,int_id")
        .like("username", "%$username%")
        .not("id", "eq", supabase.auth.currentUser?.id)
        .withConverter(
          (user) => user.map(Users.fromJson).toList(),
        );
  }

  Future<void> saveChat(Users user) async {
    final users = isar.collection<Users>();
    await isar.writeTxn(() async => await users.put(user));
  }

  Future<List<Users>> getChats() async {
    final users = isar.collection<Users>();
    return await users.where().findAll();
  }
}
