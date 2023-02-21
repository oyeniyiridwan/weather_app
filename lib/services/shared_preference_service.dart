import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService{
  static SharedPreferenceService? _instance;
  static SharedPreferences? _preferences;

  static Future<SharedPreferenceService> getInstance() async {
    _instance ??= SharedPreferenceService();
    _preferences ??= await SharedPreferences.getInstance();
    return _instance!;
  }
  Future setStringList(String key, List<String> value) async {
    await _preferences!.setStringList(key, value);
  }
  List<String>? getStringList(String key) {
    return _preferences?.getStringList(key);
  }
  Future setString(String key, String value) async {
    await _preferences!.setString(key, value);
  }
  String? getString(String key) {
    return _preferences?.getString(key);
  }
}
