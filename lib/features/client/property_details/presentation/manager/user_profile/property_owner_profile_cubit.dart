
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_real_estate/features/client/property_details/domain/repo/property_details_repo.dart';

import 'property_owner_profile_state.dart';

class PropertyOwnerProfileCubit extends Cubit<PropertyOwnerProfileState> {
  final PropertyDetailsRepository _repository;

  PropertyOwnerProfileCubit(this._repository) : super(PropertyOwnerProfileInitial());

  Future<void> getPropertyOwnerProfile(int userId) async {
    emit(PropertyOwnerProfileLoading());
    try {
      final profile = await _repository.getPropertyOwnerProfileById(userId);
      emit(PropertyOwnerProfileLoaded(profile));
    } catch (error) {
      emit(PropertyOwnerProfileError('Failed to fetch property owner profile: $error'));
    }
  }
}
