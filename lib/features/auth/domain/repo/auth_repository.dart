import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/model/login_model/response_login_model.dart';
import '../../data/model/signup_model/response_signup_model.dart';
import '../../data/remote/auth_api.dart';

class AuthRepository {
  final AuthApi authApi;
  final _db = FirebaseFirestore.instance;

  AuthRepository({required this.authApi});


  /// for signup
  Future<ResponseSignUpModel> signUp(
      {required String email,
      required String phoneNumber,
      required String username,
      required String password,
      required String name,
      required String userType}) async {
    try {
      return await authApi.signUp(
        email,
        phoneNumber,
        username,
        password,
        name,
        userType,
      );
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  Future<void> saveUserRecordFirebase(ResponseLoginModel user) async{
    try {
      await _db.collection('Users').doc(user.userId.toString()).set(
        user.toJson(),
        SetOptions(merge: true),
      );
    } catch (e) {
      throw "something went wrong";
    }
  }

  Future<void> saveUsers() async {
    try {
      final List<ResponseLoginModel> users  = [
        ResponseLoginModel(userId: 1, email: 'user1@example.com', token: 'user1'),
        ResponseLoginModel(userId: 2, email: 'user2@example.com', token: 'user2'),
        ResponseLoginModel(userId: 3, email: 'user3@example.com', token: 'user3'),
        // Add more users as needed
      ];
      final batch = _db.batch();
      for (final user in users) {
        final userDocRef = _db.collection('Users').doc(user.userId.toString());
        batch.set(userDocRef, user.toJson(), SetOptions(merge: true));
      }
      await batch.commit();
    } catch (e) {
      throw "Something went wrong";
    }
  }
  /// for login
  Future<ResponseLoginModel> login(String username, String password) async {
    try {
      return await authApi.login(username, password);
    } catch (e){
      throw Exception('Failed to login up: $e');
    }
  }
}