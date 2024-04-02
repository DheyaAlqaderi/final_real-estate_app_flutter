import 'package:smart_real_estate/features/client/home/data/models/property/property_model.dart';

abstract class PropertyStateState {}

class InitPropertyStateState extends PropertyStateState {}

class LoadingPropertyStateState extends PropertyStateState {}

class SuccessPropertyStateState extends PropertyStateState {
  PropertyModel propertyModel;
  SuccessPropertyStateState(this.propertyModel);
}

class ErrorPropertyStateState extends PropertyStateState {
  String error;
  ErrorPropertyStateState(this.error);
}