
class SignupRequest {
  String email;
  String username;
  String password;

  SignupRequest({
    required this.email,
    required this.username,
    required this.password,
  });

  SignupRequest copyWith({
    String? email,
    String? username,
    String? password,
  }) {
    return SignupRequest(
      email: email ?? this.email,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'username': username,
      'password': password,
    };
  }
}
