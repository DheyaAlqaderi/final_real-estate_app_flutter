
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

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

  // static  getCurrent(Context context){
  //   Locales.currentLocale(context);
  // }

  static bool isEnglish(){
    return Intl.getCurrentLocale() == 'en';
  }
}