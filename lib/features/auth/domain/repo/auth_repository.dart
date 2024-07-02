

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_real_estate/core/constant/app_constants.dart';

import '../../../../core/helper/local_data/shared_pref.dart';
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

  /// for logout
  static Future<void> logout() async {
    try {
      final Dio dio = Dio();
      var mToken = await _loadToken();
      String token = mToken.toString();
      final response = await dio.post(
        '${AppConstants.baseUrl}api/auth/logout/',
        options: Options(headers: {'Authorization': '$token'}),
      );

      // Check if response was successful (status code 200-299)
      if (response.statusCode == 200) {
        // Show success toast using GetX
        Get.snackbar(
          'Success',
          'Logged out successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
        await SharedPrefManager.deleteData(AppConstants.userId);
        await SharedPrefManager.deleteData(AppConstants.token);
        await SharedPrefManager.deleteData(AppConstants.userType);

      } else {
        throw Exception('Failed to logout'); // Handle specific error cases here
      }
    } catch (e) {
      // Handle Dio errors or other exceptions
      Get.snackbar(
        'Error',
        'Failed to logout: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  static Future<String> _loadToken() async {
    await SharedPrefManager.init();
    String? loadedToken = await SharedPrefManager.getData(AppConstants.token);
    if (loadedToken == null || loadedToken.isEmpty) {
      return " ";
    }
    return "token $loadedToken";
  }
}