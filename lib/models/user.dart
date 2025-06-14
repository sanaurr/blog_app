

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User with ChangeNotifier {
  final SharedPreferences _sharedPreferences;
  String? _name;
  String? _id;
  String? _accessToken;
  String? _refreshToken;

  User._(this._sharedPreferences) {
    _accessToken = _sharedPreferences.getString('accessToken');
    _refreshToken = _sharedPreferences.getString('refreshToken');
    _decode();
  }

  static Future<User> init() async {
    return User._(await SharedPreferences.getInstance());
  }

  bool get isAuthenticated => _accessToken != null;
  String get name => _name!;
  String get id => _id!;
  String get accessToken => _accessToken!;
  String get refreshToken => _refreshToken!;

  set accessToken(String? accessToken) {
    _accessToken = accessToken;
    if (accessToken == null) {
      _sharedPreferences.remove('accessToken');
    } else { 
      _sharedPreferences.setString('accessToken', accessToken);
    }
    _decode();
  }

  set refreshToken(String? refreshToken) {
    _refreshToken = refreshToken;
    if (refreshToken == null) {
      _sharedPreferences.remove('refreshToken');
    } else {
      _sharedPreferences.setString('refreshToken', refreshToken);
    }
  }

  void _decode() {
    if (_accessToken != null) {
      final payloadMap = JwtDecoder.decode(_accessToken!);
      _name = payloadMap['name'];
      _id = payloadMap['id'];
    } else {
      _name = null;
      _id = null;
    }
  }

  Future<bool> login(Map<String, dynamic> data) async {
    accessToken = data['accessToken']!;
    refreshToken = data['refreshToken']!;
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    accessToken = null;
    refreshToken = null;
    notifyListeners();
  }
}
