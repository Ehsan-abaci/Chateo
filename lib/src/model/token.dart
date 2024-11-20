import 'dart:convert';

class Token {
  String accessToken;
  Token({
    required this.accessToken,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'access_token': accessToken,
    };
  }

  factory Token.fromMap(Map<String, dynamic> map) {
    return Token(
      accessToken: map['access_token'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Token.fromJson(String source) => Token.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Token(accessToken: $accessToken,\n';
}
