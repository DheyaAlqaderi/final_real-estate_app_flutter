
import 'package:flutter/foundation.dart';

import '../../../../../core/constant/app_constants.dart';
import '../../../../../core/helper/local_data/shared_pref.dart';
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
      var mToken = await _loadToken();
      String token = mToken.toString();
      final response = await _highStateApi.getPropertyByState(
          pageNumber, pageSize, stateId, token);

      if (kDebugMode) {
        print("state property success ");
      }
      return response;
    } catch(e){
      if (kDebugMode) {
        print("error ${e.hashCode}");
      }
      throw Exception("$e");
    }
  }

  Future<String> _loadToken() async {
    await SharedPrefManager.init();
    String? loadedToken = await SharedPrefManager.getData(AppConstants.token);
    if (loadedToken == null || loadedToken.isEmpty) {
      return " ";
    }
    return "token $loadedToken";
  }

}