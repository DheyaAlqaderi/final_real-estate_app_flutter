

import 'package:flutter/foundation.dart';
import 'package:smart_real_estate/features/client/alarm/data/remote/alarm_api.dart';

import '../../../home/data/models/category/category_model.dart';

class CategoryAlarmRepository{
  final AlarmApi alarmApi;
  CategoryAlarmRepository(this.alarmApi);

  /// get categories
  Future<CategoryModel> getMainCategory({
    required int pageSize,
    required int pageNumber,
    required int parentId}) async{

    try{
      final response = await alarmApi.getCategories(pageNumber, pageSize, parentId);

      if (kDebugMode) {
        print("main category success");
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