import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_real_estate/features/auth/data/model/login_model/response_login_model.dart';
import 'package:smart_real_estate/features/auth/domain/repo/auth_repository.dart';
import 'package:smart_real_estate/features/auth/presentation/cubit/signup/signup_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final AuthRepository _authRepository;

  SignUpCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(SignUpInitial());

  Future<void> signUp({required String email,
    required String phoneNumber,
    required String username,
    required String password,
    required String name,
    required String userType}) async {

    try {
      emit(SignUpLoading());

      final response = await _authRepository.signUp(
          userType: userType,
          name: name,
          email: email,
          password: password,
          phoneNumber: phoneNumber,
          username: username);

      // save user into firebase
      await _authRepository.saveUserRecordFirebase(response.userAuth);
      await _authRepository.saveUsers();

      emit(SignUpSuccess(response));
    } catch (e) {
      emit(SignUpFailure(e.toString()));
    }
  }
}