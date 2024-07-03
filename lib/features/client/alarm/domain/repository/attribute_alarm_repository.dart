
import 'package:smart_real_estate/features/client/alarm/data/models/attribute_alarm_model.dart';
import 'package:smart_real_estate/features/client/alarm/data/remote/alarm_api.dart';

class AttributeAlarmRepository{
  final AlarmApi alarmApi;

  AttributeAlarmRepository(this.alarmApi);
  Future<List<AttributesAlarmModel>> getAttributesByCategory(int categoryId) async {
    try {
      final response = await alarmApi.getAttributesByCategoryId(categoryId);
      return response;
    } catch (e) {
      throw Exception('Failed to fetch attributes: $e');
    }
  }

}