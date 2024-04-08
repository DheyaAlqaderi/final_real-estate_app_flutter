
import '../../../../home/data/models/property/property_model.dart';

abstract class PropertyOwnerPropertiesState  {}

class PropertyOwnerPropertiesInitial extends PropertyOwnerPropertiesState {}

class PropertyOwnerPropertiesLoading extends PropertyOwnerPropertiesState {}

class PropertyOwnerPropertiesLoaded extends PropertyOwnerPropertiesState {
  final PropertyModel properties;
  PropertyOwnerPropertiesLoaded(this.properties);
}

class PropertyOwnerPropertiesError extends PropertyOwnerPropertiesState {
  final String message;
  PropertyOwnerPropertiesError(this.message);
}
