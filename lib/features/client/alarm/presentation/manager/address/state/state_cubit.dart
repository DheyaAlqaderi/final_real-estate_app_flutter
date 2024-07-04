

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_real_estate/features/client/alarm/presentation/manager/address/state/state_cubit_state.dart';

import '../../../../domain/repository/address_repo.dart';

class StateCubit extends Cubit<StateCubitState> {
  final AddressRepository repository;

  StateCubit({required this.repository}) : super(StateCubitInitial());

  Future<void> fetchStates({required int cityId}) async {
    emit(StateCubitLoading());
    try {
      final states = await repository.getStates(cityId);
      emit(StateCubitLoaded(states));
    } catch (e) {
      emit(StateCubitFailure(e.toString()));
    }
  }
}