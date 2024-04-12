
import '../../../data/model/login_model/response_login_model.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final ResponseLoginModel response;
  LoginSuccess(this.response);
}

class LoginFailure extends LoginState {
  final String error;
  LoginFailure(this.error);
}
