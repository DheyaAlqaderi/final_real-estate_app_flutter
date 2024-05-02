

import '../../data/model/login_model/response_login_model.dart';
import '../../data/model/signup_model/response_signup_model.dart';
import '../../data/remote/auth_api.dart';

class AuthRepository {
  final AuthApi authApi;

  AuthRepository({required this.authApi});


  /// for signup with API
  Future<ResponseSignUpModel> signUp(
      {required String email,
      required String phoneNumber,
      required String username,
      required String password,
      required String name,
      required String userType}) async {
    try {
      return await authApi.signUp(
        email,
        phoneNumber,
        username,
        password,
        name,
        userType,
      );
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  /// for login with API
  Future<ResponseLoginModel> login(String username, String password) async {
    try {
      return await authApi.login(username, password);
    } catch (e){
      throw Exception('Failed to login up: $e');
    }
  }
}