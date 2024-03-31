import 'package:smart_real_estate/features/client/home/data/models/property/property_model.dart';

abstract class PropertyState {}

class InitPropertyState extends PropertyState {}

class LoadingPropertyState extends PropertyState {}

class SuccessPropertyState extends PropertyState {
  PropertyModel propertyModel;
  SuccessPropertyState(this.propertyModel);
}

class ErrorPropertyState extends PropertyState {
  String error;
  ErrorPropertyState(this.error);
}