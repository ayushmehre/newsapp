import 'dart:convert';

import 'package:newsapp/models/UserObject.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserUtils {
  static final USER_OBJECT_KEY = "userObject";

  UserUtils._();

  static Future<UserObject> getCurrentUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? shstr = sharedPreferences.getString(USER_OBJECT_KEY);
    Map<String, dynamic> userObject = jsonDecode(shstr.toString());
    print("\n\n getCurrentUser: ${UserObject.fromJson(userObject)}");
    return UserObject.fromJson(userObject);
  }

  static saveUserObject(UserObject userObj) async {
    print("\n\n \n\n userObj: ${userObj.toJson()}");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // var tmp=json.encode(userObj.toJson());
    sharedPreferences.setString(USER_OBJECT_KEY, json.encode(userObj.toJson()));
  }
}
