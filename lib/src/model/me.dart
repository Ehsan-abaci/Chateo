import 'dart:convert';

import 'package:ehsan_chat/src/model/token.dart';

class Me {
  int userId;
  String? firstname;
  String? lastname;
  String username;
  String email;
  Token token;
  String? avatar;
  Me({
    required this.userId,
    this.firstname,
    this.lastname,
    required this.username,
    required this.email,
    required this.token,
    this.avatar,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': userId,
      'firstname': firstname,
      'lastname': lastname,
      'username': username,
      'email': email,
      'token': token.toMap(),
      'avatar': avatar,
    };
  }

  factory Me.fromMap(Map<String, dynamic> map) {
    final userMap = map['user'];
    return Me(
      userId: userMap['id'] as int,
      firstname: userMap['firstname'] != null ? userMap['firstname'] as String : null,
      lastname: userMap['lastname'] != null ? userMap['lastname'] as String : null,
      username: userMap['username'] as String,
      email: userMap['email'] as String,
      token: Token.fromMap(map['token'] as Map<String, dynamic>),
      avatar: userMap['avatar'] != null ? userMap['avatar'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Me.fromJson(String source) =>
      Me.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Me(userId: $userId, firstname: $firstname, lastname: $lastname, username: $username, email: $email, token: $token, avatar: $avatar)';
  }
}
