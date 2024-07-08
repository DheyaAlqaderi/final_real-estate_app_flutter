class RequestSignUpModel {
  final String email;
  final String phoneNumber;
  final String username;
  final String password;
  final String name;
  final String userType;
  final String deviceToken;


  RequestSignUpModel( {
    required this.email,
    required this.phoneNumber,
    required this.username,
    required this.password,
    required this.name,
    required this.userType,
    required this.deviceToken
  });

  factory RequestSignUpModel.fromJson(Map<String, dynamic> json) {
    return RequestSignUpModel(
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      name: json['name'] ?? '',
      userType: json['user_type'] ?? '',
      deviceToken: json['user_type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'phone_number': phoneNumber,
      'username': username,
      'password': password,
      'name': name,
      'user_type': userType,
      'device_token': deviceToken
    };
  }
}
