import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/user.dart';

class RememberUserPreferences {
  static const String _userKey = 'user';

  static Future<void> saveUserInfo(String userInfo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, userInfo);
  }

  static Future<String?> readUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userKey);
  }

  static Future<void> removeUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
// }
//   static Future<void> removeUserInfo() async
//   {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     await preferences.remove("CurrentUser");
//   }
}
