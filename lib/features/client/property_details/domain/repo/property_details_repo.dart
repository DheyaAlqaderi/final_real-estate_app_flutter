import 'package:smart_real_estate/features/client/property_details/data/remote_api/property_details_api.dart';

import '../../../home/data/models/property/property_model.dart';
import '../../data/model/property_details_model.dart';
import '../../data/model/review_model.dart';
import '../../data/model/user_profile_model.dart';

class PropertyDetailsRepository {
  final PropertyDetailsApi _api;

  PropertyDetailsRepository(this._api);


  /// to get property details
  Future<PropertyDetailsModel> getPropertyDetailsById(int propertyId, String token) async {
    try {
      return await _api.getPropertyDetailsById(propertyId, "token $token");
    } catch (error) {
      throw Exception('Failed to fetch property details: $error');
    }
  }

  /// to get property reviews
  Future<ReviewModel> getReviewsPropertyById(int propertyId) async {
    try {
      return await _api.getReviewsPropertyById(propertyId, "-time_created");
    } catch (e) {
      // Handle error
      throw Exception('Failed to fetch property reviews');
    }
  }

  /// to get property reviews by rate number
  Future<ReviewModel> getReviewsPropertyByRateNo(int propertyId, int rateReview) async {
    try {
      return await _api.getReviewsPropertyByRateNo(propertyId, rateReview, "-time_created");
    } catch (e) {
      throw Exception('Failed to fetch property reviews by rate number');
    }
  }

  /// to get property owner profile by userId
  Future<ProfileUserModel> getPropertyOwnerProfileById(int userId) async {
    try {
      return await _api.getPropertyOwnerProfileById(userId);
    } catch (error) {
      // Handle error
      throw Exception('Failed to fetch property owner profile: $error');
    }
  }

  /// to get property owner properties by userId
  Future<PropertyModel> getPropertyOwnerPropertiesByUserId(int userId) async {
    try {
      return await _api.getPropertyOwnerPropertiesByUserId(userId);
    } catch (error) {
      // Handle error
      throw Exception('Failed to fetch property owner properties: $error');
    }
  }

}
