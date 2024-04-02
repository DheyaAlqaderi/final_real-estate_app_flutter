import 'package:smart_real_estate/features/client/home/data/models/property/property_model.dart';

abstract class PropertyHomeState {}

class InitPropertyHomeState extends PropertyHomeState {}

class LoadingPropertyHomeState extends PropertyHomeState {}

class SuccessPropertyHomeState extends PropertyHomeState {
  PropertyModel propertyModel;
  SuccessPropertyHomeState(this.propertyModel);
}

class ErrorPropertyHomeState extends PropertyHomeState {
  String error;
  ErrorPropertyHomeState(this.error);
}