
import 'package:smart_real_estate/features/client/alarm/data/models/city_model.dart';



abstract class CityCubitState{}

class CityCubitInitial extends CityCubitState {}

class CityCubitLoading extends CityCubitState {}

class CityCubitLoaded extends CityCubitState {
  final List<CityModel> countries;

  CityCubitLoaded(this.countries);
}



class CityCubitFailure extends CityCubitState {
  final String error;

  CityCubitFailure(this.error);
}
