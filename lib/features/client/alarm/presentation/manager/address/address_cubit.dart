

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repository/address_repo.dart';
import 'address_cubit_state.dart';

class AddressCubit extends Cubit<AddressState> {
  final AddressRepository repository;

  AddressCubit({required this.repository}) : super(AddressInitial());

  Future<void> fetchCountries() async {
    emit(AddressCoLoading());
    try {
      final countries = await repository.getCountries();
      emit(AddressCountriesLoaded(countries));
    } catch (e) {
      emit(AddressFailure(e.toString()));
    }
  }

  Future<void> fetchCities(int countryId) async {
    emit(AddressCiLoading());
    try {
      final cities = await repository.getCities(countryId);
      emit(AddressCitiesLoaded(cities));
    } catch (e) {
      emit(AddressFailure(e.toString()));
    }
  }

  Future<void> fetchStates(int cityId) async {
    emit(AddressStLoading());
    try {
      final response = await repository.getStates(cityId);
      emit(AddressStatesLoaded(response));
    } catch (e) {
      emit(AddressFailure(e.toString()));
    }
  }
}
