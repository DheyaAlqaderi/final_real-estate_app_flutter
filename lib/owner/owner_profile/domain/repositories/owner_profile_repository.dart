
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import '../../../../../core/constant/app_constants.dart';
import '../../../../features/client/profile/data/models/profile_model.dart';
import '../../../../features/client/profile/data/models/user_update_response.dart';

part 'owner_profile_repository.g.dart';

@RestApi(baseUrl: AppConstants.baseUrl2)

abstract class OwnerProfileRepository{
  factory OwnerProfileRepository(Dio dio ,{String baseUrl}) = _OwnerProfileRepository ;

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