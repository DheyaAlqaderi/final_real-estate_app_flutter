
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import '../../../../../core/constant/app_constants.dart';
import '../../data/models/profile_model.dart';
import '../../data/models/user_update_response.dart';

part 'profile_repository.g.dart';

@RestApi(baseUrl: AppConstants.baseUrl2)

abstract class ProfileRepository{
  factory ProfileRepository(Dio dio ,{String baseUrl}) = _ProfileRepository ;

  @GET("api/user/profile/{id}/")
  Future<ProfileModel> getProfile(
      @Path("id")int id
      );
  
  @PATCH("api/user/profile/update/")
  Future<UserUpdateResponse> updateProfile(
      @Header("Authorization")String token,
      @Body() Map<String, dynamic> user,
      );

  @PATCH("api/user/profile/update/")
  Future<UserUpdateResponse> updateProfile2(
      @Header("Authorization")String token,
      @Part(name: "image") File image
      );
}


