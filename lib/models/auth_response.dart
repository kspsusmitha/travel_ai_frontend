class AuthResponse {
  final String token;
  final int userId;
  final String username;

  AuthResponse({
    required this.token,
    required this.userId,
    required this.username,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] as String,
      userId: json['user_id'] as int,
      username: json['username'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user_id': userId,
      'username': username,
    };
  }
}
