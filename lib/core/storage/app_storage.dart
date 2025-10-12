import 'dart:convert';

import 'package:easy_order/app/firebase_services/model/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStorage {
  /// Save a string value to SharedPreferences

  AppStorage._internal();

  static final AppStorage _instance = AppStorage._internal();

  factory AppStorage() {
    return _instance;
  }

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<void> initialAppRunCheck() async {
    final prefs = await SharedPreferences.getInstance();
    final hasRunBefore = prefs.getBool('hasRunBefore') ?? false;

    if (!hasRunBefore) {
      await clearUser();
      await prefs.setBool('hasRunBefore', true);
    }
  }

  static Future<void> saveUser(UserModel user) async {
    String jsonString = json.encode(user.toMap());
    await _storage.write(key: 'current_user', value: jsonString);
  }

  static Future<UserModel?> get getUser async {
    final userJson = await _storage.read(key: 'current_user');
    if (userJson != null) {
      Map<String, dynamic> userMap = json.decode(userJson);
      return UserModel.fromMap(userMap);
    }
    return null;
  }

  static Future<void> clearUser() async {
    await _storage.delete(key: 'current_user');
  }
}
