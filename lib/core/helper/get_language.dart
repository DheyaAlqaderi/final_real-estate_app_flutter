
import 'dart:ui' as ui;

import 'package:flutter/services.dart';

class GetLanguage{
  static  String? getDeviceLanguage() {
    String? deviceLanguage;
    try{
      deviceLanguage = ui.window.locale.languageCode;
    } on PlatformException {
      deviceLanguage = null;
    }
    return deviceLanguage;
  }
}