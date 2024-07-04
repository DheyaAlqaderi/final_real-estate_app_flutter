

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_real_estate/features/client/alarm/presentation/manager/address/country/country_cubit_state.dart';

import '../../../../domain/repository/address_repo.dart';

class CountryCubit extends Cubit<CountryCubitState> {
  final AddressRepository repository;

  CountryCubit({required this.repository}) : super(CountryCubitInitial());

  Future<void> fetchCountries() async {
    emit(CountryCubitLoading());
    try {
      final countries = await repository.getCountries();
      emit(CountryCubitLoaded(countries));
    } catch (e) {
      emit(CountryCubitFailure(e.toString()));
    }
  }
}