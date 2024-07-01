import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../auth/presentation/pages/both_auth_screen.dart';

void showLoginPopup() {
  Get.defaultDialog(
    title: 'Not Logged In',
    titleStyle: const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    middleText: 'You are not logged in. You have to log in.',
    middleTextStyle: const TextStyle(
      fontSize: 18,
      color: Colors.black54,
    ),
    radius: 10,
    content: const Column(
      children: [
        Icon(
          Icons.lock_outline,
          color: Colors.redAccent,
          size: 80,
        ),
        SizedBox(height: 20),
        Text(
          'You are not logged in. You have to log in.',
          style: TextStyle(fontSize: 16, color: Colors.black87),
          textAlign: TextAlign.center,
        ),
      ],
    ),
    textConfirm: 'Log In',
    confirmTextColor: Colors.white,
    onConfirm: () {
      // Implement your login logic here
      Get.to(() => const BothAuthScreen(isOwner: false));
    },
    textCancel: 'Cancel',
    cancelTextColor: Colors.redAccent,
    onCancel: () {},
    buttonColor: Colors.redAccent,
  );
}
