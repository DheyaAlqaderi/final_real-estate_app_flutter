import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';
import 'package:smart_real_estate/owner/home/data/models/activate_model.dart';
import 'package:smart_real_estate/owner/home/data/models/activate_property_model.dart';
import '../../../../core/constant/app_constants.dart';
import '../../../../features/client/home/data/models/property/property_model.dart';
part 'property_owner_repositories.g.dart';

@RestApi(baseUrl: AppConstants.baseUrl2)
abstract class OwnerPropertyRepository{
  factory OwnerPropertyRepository(Dio dio, {String baseUrl}) = _OwnerPropertyRepository;

  @GET('api/property/')
  Future<PropertyModel?> getPropertyOwnerByUserId(
      @Query("user") int userId,
      @Query("page_size") int pageSize,
      @Header("Authorization") String token
      );

  @PUT('api/property/{id}/update/')
  Future<ActivatePropertyModel> activateProperty(
      @Body() ActivateModel activateModel,
      @Path("id") String id,
      @Header("Authorization") String token
    );


}