import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DarkToLightTheme with ChangeNotifier {
  final String key = "Dark";
  bool _isDark = false;
  SharedPreferences _preferences;
  bool get isDark => _isDark;

  changeTheme(bool value) async {
    await _initPreps();
    _isDark = value;
    _savePrep();
    notifyListeners();
  }

  _initPreps() async {
    if (_preferences == null)
      _preferences = await SharedPreferences.getInstance();
  }

  // Future<bool> _getDataFromPrep() async {
  //   return _preferences.getBool(key);
  // }

  _savePrep() async {
    _preferences.setBool(key, _isDark);
  }
}
