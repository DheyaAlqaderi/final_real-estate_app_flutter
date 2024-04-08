
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:smart_real_estate/core/constant/app_constants.dart';
import 'package:smart_real_estate/features/client/home/data/models/property/property_model.dart';
import 'package:smart_real_estate/features/client/property_details/data/model/property_details_model.dart';

import '../model/review_model.dart';
import '../model/user_profile_model.dart';

part 'property_details_api.g.dart';

@RestApi(baseUrl: AppConstants.baseUrl)
abstract class PropertyDetailsApi{
  factory PropertyDetailsApi(Dio dio, {String baseUrl}) = _PropertyDetailsApi;


  /// get properties by id
  @GET('api/property/{propertyId}/')
  Future<PropertyDetailsModel> getPropertyDetailsById(
    @Path("propertyId") int propertyId,
    @Header("Authorization") String token,
  );

  /// get Reviews of property id
  @GET('api/property/{propertyId}/reviews/')
  Future<ReviewModel> getReviewsPropertyById(
      @Path("propertyId") int propertyId,
      @Query("ordering") String timeCreated,
      );

  /// get Reviews of rate number
  @GET('api/property/{propertyId}/reviews/')
  Future<ReviewModel> getReviewsPropertyByRateNo(
      @Path("propertyId") int propertyId,
      @Query("rate_review") int rateReview,
      @Query("ordering") String timeCreated,
      );

  /// get Owner Property profile
  @GET('api/user/profile/{userId}/')
  Future<ProfileUserModel> getPropertyOwnerProfileById(
      @Path("userId") int userId,
      );

  /// get Owner Property properties
  @GET('api/property/')
  Future<PropertyModel> getPropertyOwnerPropertiesByUserId(
      @Query("user") int userId,
      );

}