
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_real_estate/features/client/property_details/domain/repo/property_details_repo.dart';
import 'package:smart_real_estate/features/client/property_details/presentation/manager/owner_properties/property_owner_properties._sate.dart';

class PropertyOwnerPropertiesCubit extends Cubit<PropertyOwnerPropertiesState> {
  final PropertyDetailsRepository _repository;

  PropertyOwnerPropertiesCubit(this._repository) : super(PropertyOwnerPropertiesInitial());

  Future<void> getPropertyOwnerProperties(int userId) async {
    emit(PropertyOwnerPropertiesLoading());
    try {
      final properties = await _repository.getPropertyOwnerPropertiesByUserId(userId);
      emit(PropertyOwnerPropertiesLoaded(properties));
    } catch (error) {
      emit(PropertyOwnerPropertiesError('Failed to fetch property owner properties: $error'));
    }
  }
}
