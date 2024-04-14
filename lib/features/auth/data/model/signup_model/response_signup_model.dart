import 'package:smart_real_estate/features/auth/data/model/login_model/response_login_model.dart';

// class UserAuth {
//   final String token;
//   final int userId;
//   final String email;
//
//   UserAuth({
//     required this.token,
//     required this.userId,
//     required this.email,
//   });
//
//   factory UserAuth.fromJson(Map<String, dynamic> json) {
//     return UserAuth(
//       token: json['token'] ?? '',
//       userId: json['user_id'] ?? 0,
//       email: json['email'] ?? '',
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'token': token,
//       'user_id': userId,
//       'email': email,
//     };
//   }
// }

class ResponseSignUpModel {
  final int id;
  final String email;
  final String phoneNumber;
  final String username;
  final String name;
  final String? image;
  final ResponseLoginModel userAuth;
  final String userType;

  ResponseSignUpModel({
    required this.id,
    required this.email,
    required this.phoneNumber,
    required this.username,
    required this.name,
    required this.image,
    required this.userAuth,
    required this.userType,
  });

  factory ResponseSignUpModel.fromJson(Map<String, dynamic> json) {
    return ResponseSignUpModel(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      username: json['username'] ?? '',
      name: json['name'] ?? '',
      image: json['image'],
      userAuth: ResponseLoginModel.fromJson(json['user_auth'] ?? {}),
      userType: json['user_type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone_number': phoneNumber,
      'username': username,
      'name': name,
      'image': image,
      'user_auth': userAuth.toJson(),
      'user_type': userType,
    };
  }
}
