// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
class User {
  int id;
  String username;
  String? firstname;
  String? lastname;
  String? avatar;

  User({
    required this.id,
    required this.username,
    this.firstname,
    this.lastname,
    this.avatar,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'avatar': avatar,
      'username': username,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int,
      firstname: map['firstname'] != null ? map['firstname'] as String : null,
      lastname: map['lastname'] != null ? map['lastname'] as String : null,
      avatar: map['avatar'] != null ? map['avatar'] as String : null,
      username: map['username'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(id: $id, firstname: $firstname, lastname: $lastname, avatar: $avatar, username: $username)';
  }
}
