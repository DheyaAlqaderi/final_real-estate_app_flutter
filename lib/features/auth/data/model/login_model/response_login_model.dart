class ResponseLoginModel {
  final String token;
  final int userId;
  final String email;

  ResponseLoginModel({
    required this.token,
    required this.userId,
    required this.email,
  });

  factory ResponseLoginModel.fromJson(Map<String, dynamic> json) {
    return ResponseLoginModel(
      token: json['token'] ?? '',
      userId: json['user_id'] ?? 0,
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user_id': userId,
      'email': email,
    };
  }
}
