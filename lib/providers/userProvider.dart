import 'dart:convert';

import 'package:advanced_mobile_dev/api/api.dart';
import 'package:advanced_mobile_dev/models/user-model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class User {
  final String id;
  final String email;
  String password;
  DateTime birthday;
  String phone;
  String country;
  String level;
  String imageUrl;
  final String fullName;

  User(this.id, this.email, this.password, this.birthday, this.phone, this.country, this.level, this.imageUrl, this.fullName);

  User.fromMap(Map map)
      : id = map['id'],
        email = map['email'],
        birthday = DateTime.tryParse(map['birthday']) ?? DateTime.now(),
        password = map['password'],
        phone = map['phone'],
        country = map['country'],
        level = map['level'],
        imageUrl = map['imageUrl'],
        fullName = map['fullName'];

  Map toMap() {
    return {
      'id': id,
      'email': email,
      'birthday': birthday.toIso8601String(),
      'password': password,
      'phone': phone,
      'country': country,
      'level': level,
      'imageUrl': imageUrl,
      'fullName': fullName,
    };
  }
}

class UserProvider with ChangeNotifier {
  List<User> _usersList = [];
  UserModel? userModel;
  UserModel? _currentUser;
  bool _authenticated = false;
  late SharedPreferences prefs;
  var api = Api().api;
  String _errorMessage = '';

  UserProvider() {
    setup();
  }

  void setup() async {
    prefs = await SharedPreferences.getInstance();
    loadData();
  }

  void saveData() async {
    List<String> spList =
    _usersList.map((item) => json.encode(item.toMap())).toList();
    await prefs.setStringList('users', spList);
    await prefs.setString('currentUser', json.encode(_currentUser?.toJson()));
    await prefs.setString('authenticated', _authenticated.toString());
  }

  void loadData() async {
    List<String> spList = await prefs.getStringList('users') ?? [];
    String? currentUserFromPrefs = await prefs.getString('currentUser');
    _usersList = spList.map((item) => User.fromMap(json.decode(item))).toList();
    _authenticated = await prefs.getString('authenticated') == 'true' ? true : false;
    // _currentUser = _authenticated ? User.fromMap(json.decode(currentUserFromPrefs!)) : User('', '', '', DateTime.now(), '', 'Vietnam', 'Beginner', '', '');
    notifyListeners();
  }

  String get errorMessage {
    return _errorMessage;
}

  bool get authenticated {
    return _authenticated;
  }

  UserModel? get currentUser {
    return _currentUser;
  }

  Future<void> login (email, password) async {
    try {
      var resp = await api.post(
          '/auth/login', data: {"email": email, "password": password});
      _currentUser = UserModel.fromJson(resp.data['user']);
      Map<String, dynamic> token = {'accessToken': resp.data['tokens']['access']['token'], 'refreshToken': resp.data['tokens']['refresh']['token']};
      prefs.setString('auth', token.toString());
      prefs.setString('currentUser', resp.data['user'].toString());
      _authenticated = true;
    } on DioError catch (e) {
      if (e.response != null) {
        _errorMessage = e.response?.data['message'];
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.message);
      }
      _authenticated = false;
    }
    // _authenticated = true;
    // saveData();
    notifyListeners();
  }

  void logout() {
    _authenticated = false;
    prefs.clear();
    saveData();
    notifyListeners();
  }

  bool isExisted(String email, String password) {
    bool checkExited = _usersList.any((element) => element.email == email && element.password == password);
    if (checkExited) {
      // _currentUser = _usersList.firstWhere((element) => element.email == email && element.password == password);
      saveData();
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
    User newUser = User(const Uuid().v4(), email, password, DateTime.now(), '', 'Vietnam', 'Beginner', '', fullName);
    _usersList.add(newUser);
    // _currentUser = newUser;
    saveData();
    notifyListeners();
  }

  void updateProfile(DateTime birthday, String phone, String country, String level, String imageUrl) {
    // _currentUser.birthday = birthday;
    // _currentUser.phone = phone;
    // _currentUser.country = country;
    // _currentUser.level = level;
    // _currentUser.imageUrl = imageUrl;
    saveData();
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