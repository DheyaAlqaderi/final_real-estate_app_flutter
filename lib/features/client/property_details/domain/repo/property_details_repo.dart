import 'package:smart_real_estate/features/client/property_details/data/remote_api/property_details_api.dart';

import '../../data/model/property_details_model.dart';

class PropertyDetailsRepository {
  final PropertyDetailsApi _api;

  PropertyDetailsRepository(this._api);

  Future<PropertyDetailsModel> getPropertyDetailsById(int propertyId, String token) async {
    try {
      return await _api.getPropertyDetailsById(propertyId, "token $token");
    } catch (error) {
      throw Exception('Failed to fetch property details: $error');
    }
  }
}
