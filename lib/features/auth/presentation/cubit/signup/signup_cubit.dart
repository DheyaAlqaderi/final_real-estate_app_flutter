import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_real_estate/features/auth/domain/repo/auth_repository.dart';
import 'package:smart_real_estate/features/auth/presentation/cubit/signup/signup_state.dart';

import '../../../../client/chat/domain/repository/firebase_messaging_repository.dart';

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

      final token =await FirebaseMessagingRepository.init();
      final response = await _authRepository.signUp(
          userType: userType,
          name: name,
          email: email,
          password: password,
          phoneNumber: phoneNumber,
          username: username,
      deviceToken: token!);

      emit(SignUpSuccess(response));
    } catch (e) {
      emit(SignUpFailure(e.toString()));
    }
  }
}