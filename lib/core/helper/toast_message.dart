import 'dart:async';

import 'package:flutter/material.dart';

class ToastAlert {
  static void show(BuildContext context, String message, {int duration = 2}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Align(alignment: Alignment.center,child: Text("Message")),
          content: Text(message),
        );
      },
    );

    // Automatically close the dialog after duration
    Timer(Duration(seconds: duration), () {
      Navigator.of(context).pop();
    });
  }
}