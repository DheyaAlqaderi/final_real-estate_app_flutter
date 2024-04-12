import '../../../data/model/signup_model/response_signup_model.dart';

abstract class SignUpState  {}

class SignUpInitial extends SignUpState {}

class SignUpLoading extends SignUpState {}

class SignUpSuccess extends SignUpState {
  final ResponseSignUpModel response;
  SignUpSuccess(this.response);
}

class SignUpFailure extends SignUpState {
  final String error;
  SignUpFailure(this.error);
}