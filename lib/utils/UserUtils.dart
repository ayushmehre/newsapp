import 'dart:convert';

import 'package:qrious_createrapp/models/UserObject.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserUtils {
  UserUtils._();

  static Future<UserObject> getCurrentUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map<String, dynamic> userObject = jsonDecode(sharedPreferences.getString('userObject')??'{}');
    return UserObject.fromJson(userObject);
  }
}
