import 'package:flutter/foundation.dart';

class LanguageProvider with ChangeNotifier {
  String _locale = 'en';

  String get locale {
    return _locale;
  }

  void changeLocale() {
    if (_locale == 'en') {
      _locale = 'vi';
    } else {
      _locale = 'en';
    }

    notifyListeners();
  }
}