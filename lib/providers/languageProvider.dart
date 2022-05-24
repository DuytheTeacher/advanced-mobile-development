import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  String _locale = 'en';

  LanguageProvider() {
    setup();
  }

  void setup() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _locale = preferences.getString('language')!;
  }

  void saveData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('language', _locale);
  }

  String get locale {
    return _locale;
  }

  void changeLocale() {
    if (_locale == 'en') {
      _locale = 'vi';
    } else {
      _locale = 'en';
    }
    saveData();
    notifyListeners();
  }
}