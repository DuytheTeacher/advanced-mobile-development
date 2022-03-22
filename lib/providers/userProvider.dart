import 'package:flutter/foundation.dart';

class User {
  final String email;
  final String password;
  final DateTime birthday;
  final String phone;
  final String country;
  final String level;
  final String fullName;

  User(this.email, this.password, this.birthday, this.phone, this.country, this.level, this.fullName);
}

class UserProvider with ChangeNotifier {
  final List<User> _usersList = [];
  User _currentUser = User('', '', DateTime.now(), '', '', '', '');
  bool _authenticated = false;

  bool get authenticated {
    return _authenticated;
  }

  void login() {
    _authenticated = true;
    notifyListeners();
  }

  void logout() {
    _authenticated = false;
    notifyListeners();
  }

  bool validate(String email, String password) {
    List<User> queryUser = _usersList.where((element) => element.email == email && element.password == password).toList();
    if (queryUser.isNotEmpty) {
      return false;
    }
    _currentUser = _usersList.firstWhere((element) => element.email == email && element.password == password);
    notifyListeners();
    return true;
  }

  bool validateEmail(String email) {
    List<User> queryUser = _usersList.where((element) => element.email == email).toList();
    if (queryUser.isNotEmpty) {
      return false;
    }
    return true;
  }

  void register(String email, String password, String fullName) {
    User newUser = User(email, password, DateTime.now(), '', '', '', fullName);
    _usersList.add(newUser);
    _currentUser = newUser;
    notifyListeners();
  }
}