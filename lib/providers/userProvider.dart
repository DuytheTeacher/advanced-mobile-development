import 'package:flutter/foundation.dart';

class User {
  final String email;
  String password;
  DateTime birthday;
  String phone;
  String country;
  String level;
  String imageUrl;
  final String fullName;

  User(this.email, this.password, this.birthday, this.phone, this.country, this.level, this.imageUrl, this.fullName);
}

class UserProvider with ChangeNotifier {
  final List<User> _usersList = [];
  User _currentUser = User('', '', DateTime.now(), '', 'Vietnam', 'Beginner', '', '');
  bool _authenticated = false;

  bool get authenticated {
    return _authenticated;
  }

  User get currentUser {
    return _currentUser;
  }

  void login() {
    _authenticated = true;
    notifyListeners();
  }

  void logout() {
    _authenticated = false;
    notifyListeners();
  }

  bool isExisted(String email, String password) {
    bool checkExited = _usersList.any((element) => element.email == email && element.password == password);
    if (checkExited) {
      _currentUser = _usersList.firstWhere((element) => element.email == email && element.password == password);
      notifyListeners();
      return true;
    }
    return false;
  }

  bool isEmailExisted(String email) {
    bool checkExisted = _usersList.any((element) => element.email == email);
    return checkExisted;
  }

  void register(String email, String password, String fullName) {
    User newUser = User(email, password, DateTime.now(), '', 'Vietnam', 'Beginner', '', fullName);
    _usersList.add(newUser);
    _currentUser = newUser;
    notifyListeners();
  }

  void updateProfile(DateTime birthday, String phone, String country, String level, String imageUrl) {
    _currentUser.birthday = birthday;
    _currentUser.phone = phone;
    _currentUser.country = country;
    _currentUser.level = level;
    _currentUser.imageUrl = imageUrl;
    notifyListeners();
  }

  String recoveryPassword(String email) {
    bool checkExited = _usersList.any((element) => element.email == email);
    if (checkExited) {
      User returnedUser = _usersList.firstWhere((element) => element.email == email);
      return returnedUser.password;
    }
    return '';
  }
}