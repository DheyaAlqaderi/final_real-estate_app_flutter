
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:smart_real_estate/owner/add_property/data/models/create_property_request.dart';
import 'package:smart_real_estate/owner/add_property/data/models/create_property_response.dart';

import '../../../../core/constant/app_constants.dart';

part 'add_property_api.g.dart';

@RestApi(baseUrl: AppConstants.baseUrl2)
abstract class AddPropertyApi {
  factory AddPropertyApi(Dio dio, {String baseUrl}) = _AddPropertyApi;


  /// create a property
  @POST("api/property/create/")
  Future<CreatePropertyResponse> addProperty(
      @Header("Authorization") String token,
      @Body() Map<String, dynamic> createPropertyRequest,
      );

}

