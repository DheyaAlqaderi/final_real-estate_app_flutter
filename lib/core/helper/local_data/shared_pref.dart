import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefManager {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveData(String key, String value) async {
    await _prefs.setString(key, value);
  }

  static Future<String?> getData(String key) async {
    return _prefs.getString(key);
  }

  static Future<void> updateData(String key, String value) async {
    await _prefs.setString(key, value);
  }

  static Future<void> deleteData(String key) async {
    await _prefs.remove(key);
  }
}