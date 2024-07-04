
import 'package:smart_real_estate/features/client/alarm/data/models/state_model.dart';

import '../../../data/models/city_model.dart';
import '../../../data/models/country_model.dart';

abstract class AddressState{}

class AddressInitial extends AddressState {}

class AddressCoLoading extends AddressState {}
class AddressCiLoading extends AddressState {}
class AddressStLoading extends AddressState {}

class AddressCountriesLoaded extends AddressState {
  final List<CountryModel> countries;

  AddressCountriesLoaded(this.countries);
}

class AddressCitiesLoaded extends AddressState {
  final List<CityModel> cities;

  AddressCitiesLoaded(this.cities);

}

class AddressStatesLoaded extends AddressState {
  final List<StateModel> states;

  AddressStatesLoaded(this.states);

}

class AddressFailure extends AddressState {
  final String error;

  AddressFailure(this.error);
}
