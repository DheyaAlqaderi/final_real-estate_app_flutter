import 'package:smart_real_estate/features/client/home/data/models/property/property_model.dart';

abstract class FeaturedState {}

class InitFeaturedState extends FeaturedState {}

class LoadingFeaturedState extends FeaturedState {}

class SuccessFeaturedState extends FeaturedState {
  PropertyModel propertyModel;
  SuccessFeaturedState(this.propertyModel);
}

class ErrorFeaturedState extends FeaturedState {
  String error;
  ErrorFeaturedState(this.error);
}