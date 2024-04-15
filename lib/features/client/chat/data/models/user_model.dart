
import 'package:flutter/foundation.dart' show immutable;

import '../../../../../core/constant/firebase/firebase_field_names.dart';

@immutable
class UserModel {
  final String fullName;
  final String email;
  final String password;
  final String profilePicUrl;
  final String uid;
  final List<String> sentRequests;
  final List<String> receivedRequests;

  const UserModel({
    required this.fullName,
    required this.email,
    required this.password,
    required this.profilePicUrl,
    required this.uid,
    required this.sentRequests,
    required this.receivedRequests,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      FirebaseFieldNames.fullName: fullName,
      FirebaseFieldNames.email: email,
      FirebaseFieldNames.password: password,
      FirebaseFieldNames.profilePicUrl: profilePicUrl,
      FirebaseFieldNames.uid: uid,
      FirebaseFieldNames.sentRequests: sentRequests,
      FirebaseFieldNames.receivedRequests: receivedRequests,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      fullName: map[FirebaseFieldNames.fullName] as String,
      email: map[FirebaseFieldNames.email] as String,
      password: map[FirebaseFieldNames.password] as String,
      profilePicUrl: map[FirebaseFieldNames.profilePicUrl] as String,
      uid: map[FirebaseFieldNames.uid] as String,
      sentRequests:
      List<String>.from((map[FirebaseFieldNames.sentRequests] ?? [])),
      receivedRequests:
      List<String>.from((map[FirebaseFieldNames.receivedRequests] ?? [])),
    );
  }
}
