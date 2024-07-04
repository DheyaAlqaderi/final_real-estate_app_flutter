
import '../../../../data/models/country_model.dart';


abstract class CountryCubitState{}

class CountryCubitInitial extends CountryCubitState {}

class CountryCubitLoading extends CountryCubitState {}

class CountryCubitLoaded extends CountryCubitState {
  final List<CountryModel> countries;

  CountryCubitLoaded(this.countries);
}



class CountryCubitFailure extends CountryCubitState {
  final String error;

  CountryCubitFailure(this.error);
}
