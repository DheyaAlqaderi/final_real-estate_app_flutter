
import 'package:flutter/foundation.dart';

import '../../../home/data/models/property/property_model.dart';
import '../../data/api/high_state_api.dart';

class HighPlacesRepo{
  final HighStateApi _highStateApi;
  HighPlacesRepo(this._highStateApi);


  /// get properties by state id
  Future<PropertyModel> getPropertyByState({
    required int pageSize,
    required int pageNumber,
    required int stateId}) async{

    try{
      final response = await _highStateApi.getPropertyByState(
          pageNumber, pageSize, stateId);

      if (kDebugMode) {
        print("state property success");
      }
      return response;
    } catch(e){
      if (kDebugMode) {
        print("error ${e.hashCode}");
      }
      throw Exception("$e");
    }
  }
}