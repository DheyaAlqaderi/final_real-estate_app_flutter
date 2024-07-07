
import '../data/models/create_property_response.dart';
import '../data/remote_api/add_property_api.dart';

class CreatePropertyRepository {
  final AddPropertyApi api;

  CreatePropertyRepository({required this.api});

  Future<CreatePropertyResponse> addProperty(String token, Map<String, dynamic> request) {
    return api.addProperty(token, request);
  }
}
