import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDark = false;
  late SharedPreferences prefs;

  bool get isDark {
    return _isDark;
  }

  void changeTheme() {
    _isDark = !_isDark;
    saveData();
    notifyListeners();
  }

  ThemeProvider() {
    setup();
  }

  void setup() async {
    prefs = await SharedPreferences.getInstance();
    loadData();
  }

  void saveData() async {
    await prefs.setBool('theme', _isDark);
  }

  void loadData() async {
    _isDark = await prefs.getBool('theme') ?? false;
    notifyListeners();
  }
}