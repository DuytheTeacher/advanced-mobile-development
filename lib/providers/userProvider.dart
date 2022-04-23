import 'dart:convert';

import 'package:advanced_mobile_dev/api/api.dart';
import 'package:advanced_mobile_dev/models/user-model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
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
    await prefs.setString('currentUser', json.encode(_currentUser?.toJson()));
    await prefs.setString('authenticated', _authenticated.toString());
  }

  void loadData() async {
    List<String> spList = await prefs.getStringList('users') ?? [];
    String? currentUserFromPrefs = await prefs.getString('currentUser');
    _authenticated = await prefs.getString('authenticated') == 'true' ? true : false;
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
    // saveData();
    notifyListeners();
  }

  void logout() {
    _authenticated = false;
    prefs.clear();
    saveData();
    notifyListeners();
  }

  Future<bool> register (String email, String password) async {
    try {
      await api.post(
          '/auth/register', data: {"email": email, "password": password}, options: Options(contentType: Headers.formUrlEncodedContentType));
      return true;
    } on DioError catch (e) {
      if (e.response != null) {
        _errorMessage = e.response?.data['message'];
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.message);
      }
      _authenticated = false;
      return false;
    }
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
    // bool checkExited = _usersList.any((element) => element.email == email);
    // if (checkExited) {
    //   User returnedUser = _usersList.firstWhere((element) => element.email == email);
    //   return returnedUser.password;
    // }
    return '';
  }
}