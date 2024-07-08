
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:smart_real_estate/core/constant/app_constants.dart';
import 'package:smart_real_estate/features/auth/data/model/login_model/response_login_model.dart';

import '../model/signup_model/response_signup_model.dart';

part 'auth_api.g.dart';

@RestApi(baseUrl: AppConstants.baseUrl)
abstract class AuthApi{
  factory AuthApi(Dio dio, {String baseUrl}) = _AuthApi;

  @POST("api/auth/sginup/")
  Future<ResponseSignUpModel> signUp(
      @Field('email') String email,
      @Field('phone_number') String phoneNumber,
      @Field('username') String username,
      @Field('password') String password,
      @Field('name') String name,
      @Field('user_type') String userType,
      @Field('device_token') String deviceToken,

      );

  @POST("api/auth/login/")
  Future<ResponseLoginModel> login(
      @Field('username') String username,
      @Field('password') String password,
      );

}