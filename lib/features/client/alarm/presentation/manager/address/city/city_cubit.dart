

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_real_estate/features/client/alarm/presentation/manager/address/city/city_cubit_state.dart';

import '../../../../domain/repository/address_repo.dart';

class CityCubit extends Cubit<CityCubitState> {
  final AddressRepository repository;

  CityCubit({required this.repository}) : super(CityCubitInitial());

  Future<void> fetchCities({required int countryId}) async {
    emit(CityCubitLoading());
    try {
      final cities = await repository.getCities(countryId);
      emit(CityCubitLoaded(cities));
    } catch (e) {
      emit(CityCubitFailure(e.toString()));
    }
  }
}