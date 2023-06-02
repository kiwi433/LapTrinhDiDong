import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
 static late SharedPreferences _preferences;

  static const _keyUsername = 'username';
  static const _keyPassword = 'password';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setUsername(String username) async =>
      await _preferences.setString(_keyUsername, username);

  static String? getUsername() => _preferences.getString(_keyUsername);

  static Future setPassword(String password) async =>
      await _preferences.setString(_keyPassword, password);

  static String? getPassword() => _preferences.getString(_keyPassword);

  static Future clear() async => await _preferences.clear();
}
