import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  static const String _isLoginKey = 'isLogin';
  static const String _usernameKey = 'username';

  static Future<SharedPreferences> _getSharedPreferences() async {
    return await SharedPreferences.getInstance();
  }

  Future<void> setLogin(String username) async {
    final SharedPreferences prefs = await _getSharedPreferences();
    prefs.setBool(_isLoginKey, true);
    prefs.setString(_usernameKey, username);
  }

  Future<void> setLogout() async {
    final SharedPreferences prefs = await _getSharedPreferences();
    prefs.setBool(_isLoginKey, false);
    prefs.remove(_usernameKey);
  }

  Future<String> getUsername() async {
    final SharedPreferences prefs = await _getSharedPreferences();
    return prefs.getString(_usernameKey) ?? 'notFound';
  }

  Future<bool> getLoginStatus() async {
    final SharedPreferences prefs = await _getSharedPreferences();
    return prefs.getBool(_isLoginKey) ?? false;
  }
}
