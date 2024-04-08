
import '../../../data/model/user_profile_model.dart';

abstract class PropertyOwnerProfileState {}

class PropertyOwnerProfileInitial extends PropertyOwnerProfileState {}

class PropertyOwnerProfileLoading extends PropertyOwnerProfileState {}

class PropertyOwnerProfileLoaded extends PropertyOwnerProfileState {
  final ProfileUserModel profile;
  PropertyOwnerProfileLoaded(this.profile);
}

class PropertyOwnerProfileError extends PropertyOwnerProfileState {
  final String error;
  PropertyOwnerProfileError(this.error);
}
