import 'package:isar/isar.dart';

part 'user.g.dart';

@collection
class Users {
  Id intId;
  String id;
  String fullname;
  String? username;
  String? avatar;
  Users({
    required this.intId,
    required this.id,
    required this.fullname,
    this.username,
    this.avatar,
  });

  factory Users.fromJson(Map<String, dynamic> map) {
    return Users(
      id: map['id'] as String,
      intId: map['int_id'] as Id,
      fullname: map['fullname'] as String,
      username: map['username'] != null ? map['username'] as String : null,
      avatar: map['avatar'] != null ? map['avatar'] as String : null,
    );
  }

}
