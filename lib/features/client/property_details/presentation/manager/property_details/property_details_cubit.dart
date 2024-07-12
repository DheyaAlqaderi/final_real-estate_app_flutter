import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_real_estate/features/client/property_details/presentation/manager/property_details/property_details_state.dart';

import '../../../domain/repo/property_details_repo.dart';

class PropertyDetailsCubit extends Cubit<PropertyDetailsState> {
  final PropertyDetailsRepository _repository;

  PropertyDetailsCubit(this._repository) : super(PropertyDetailsInitial());

  Future<void> getPropertyDetails(int propertyId, String token) async {
    emit(PropertyDetailsLoading());
    try {
      final propertyDetails = await _repository.getPropertyDetailsById(propertyId, token);
      emit(PropertyDetailsSuccess(propertyDetails));

        print("success Property Details");

    } catch (error) {
      if (kDebugMode) {
        print("${error}success Property Details");
      }
      emit(PropertyDetailsError(error.toString()));

    }
  }
}
