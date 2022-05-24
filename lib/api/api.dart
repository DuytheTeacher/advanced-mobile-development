import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  final Dio api = Dio();
  late SharedPreferences prefs;
  String? accessToken;

  Api() {
    api.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
      if (!options.path.contains('http')) {
        options.path = 'https://sandbox.api.lettutor.com' + options.path;
      }
      if (options.path.contains('/auth/login') ||
          options.path.contains('/auth/register')) {
        return handler.next(options);
      }
      prefs = await SharedPreferences.getInstance();
      accessToken = json.decode(prefs.getString('auth') ?? '{}')['accessToken'];
      options.headers['Authorization'] = 'Bearer $accessToken';
      return handler.next(options);
    }, onResponse: (response, handler) {
      // Do something with response data
      return handler.next(response);
      // If you want to reject the request with a error message,
      // you can reject a `DioError` object eg: `handler.reject(dioError)`
    }, onError: (DioError error, handler) async {
      if (error.response?.statusCode == 500 &&
          error.response?.data['message'] == "Please authenticate" &&
          error.response?.data['statusCode'] == 1) {
        prefs = await SharedPreferences.getInstance();
        var authObject = json.decode(prefs.getString('auth') ?? '{}');
        if (authObject['refreshToken'] != null) {
          // will throw error below
          await refreshToken();
          return handler.resolve(await _retry(error.requestOptions));
        }
      }
      prefs = await SharedPreferences.getInstance();
      prefs.setString('authenticated', 'false');
      return handler.next(error);
    }));
  }

  Future<void> refreshToken() async {
    prefs = await SharedPreferences.getInstance();
    var authObject = json.decode(prefs.getString('auth') ?? '{}');
    final refreshToken = authObject.refreshToken;
    final response = await api.post('/auth/refresh-token',
        data: {'refreshToken': refreshToken, 'timezone': 7});

    if (response.statusCode == 200) {
      accessToken = response.data['token']['access']['token'];
    } else {
      // refresh token is wrong so log out user.
      accessToken = null;
      prefs.clear();
    }
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return api.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }
}
