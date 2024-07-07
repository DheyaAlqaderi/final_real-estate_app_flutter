
import '../../../data/models/create_property_response.dart';

abstract class CreatePropertyCubitState  {
}

class CreatePropertyInitial extends CreatePropertyCubitState {}

class CreatePropertyLoading extends CreatePropertyCubitState {}

class CreatePropertySuccess extends CreatePropertyCubitState {
  final CreatePropertyResponse response;

   CreatePropertySuccess(this.response);

}

class CreatePropertyFailure extends CreatePropertyCubitState {
  final String error;

   CreatePropertyFailure(this.error);

}
