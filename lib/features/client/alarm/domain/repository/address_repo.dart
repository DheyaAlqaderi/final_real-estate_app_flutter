

import 'package:smart_real_estate/features/client/alarm/data/models/city_model.dart';
import 'package:smart_real_estate/features/client/alarm/data/models/country_model.dart';
import 'package:smart_real_estate/features/client/alarm/data/models/state_model.dart';

import '../../data/remote/alarm_api.dart';

class AddressRepository {
  final AlarmApi alarmApi;

  AddressRepository({required this.alarmApi});

  /// get Countries
  Future<List<CountryModel>> getCountries() async {
    try {
      final response = await alarmApi.getCountries();
      return response;
    } catch (e) {
      throw Exception('Failed to fetch countries: $e');
    }
  }

  /// get Cities
  Future<List<CityModel>> getCities(int countryId) async {
    try {
      final response = await alarmApi.getCities(countryId);
      return response;
    } catch (e) {
      throw Exception('Failed to fetch cities: $e');
    }
  }

  /// get State
  Future<List<StateModel>> getStates(int cityId) async {
    try {
      final response = await alarmApi.getStates(cityId);
      return response;
    } catch (e) {
      throw Exception('Failed to fetch states: $e');
    }
  }

}