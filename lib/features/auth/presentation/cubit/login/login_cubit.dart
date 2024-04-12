import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repo/auth_repository.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;

  LoginCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(LoginInitial());

  Future<void> login(String username, String password) async {
    try {
      emit(LoginLoading());
      final response = await _authRepository.login(username, password);
      emit(LoginSuccess(response));
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}
