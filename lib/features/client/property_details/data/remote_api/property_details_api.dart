

import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:smart_real_estate/core/constant/app_constants.dart';
import 'package:smart_real_estate/features/client/property_details/data/model/property_details_model.dart';

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
}