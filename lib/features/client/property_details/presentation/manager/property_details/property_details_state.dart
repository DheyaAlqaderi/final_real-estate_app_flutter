import '../../../data/model/property_details_model.dart';

abstract class PropertyDetailsState {}

class PropertyDetailsInitial extends PropertyDetailsState {}

class PropertyDetailsLoading extends PropertyDetailsState {}

class PropertyDetailsSuccess extends PropertyDetailsState {
  final PropertyDetailsModel propertyDetails;

  PropertyDetailsSuccess(this.propertyDetails);
}

class PropertyDetailsError extends PropertyDetailsState {
  final String error;

  PropertyDetailsError(this.error);
}
