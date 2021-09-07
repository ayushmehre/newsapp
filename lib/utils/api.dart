import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/services.dart' show rootBundle;

import 'package:http/http.dart' as http;
import 'package:qrious_createrapp/models/UserObject.dart';

Future<Uint8List> _readFileByte(File filePath) async {
  print("\n 11111: \n");
  Uint8List bytes = filePath.readAsBytesSync();
  print("\n 22222:");
  return Uint8List.view(bytes.buffer);
}

class API {
  static final BASE_URL =
      "https://akugo8ysj8.execute-api.ap-south-1.amazonaws.com/dev";
  static final BASE_URL_DEFAULT =
      "https://akugo8ysj8.execute-api.ap-south-1.amazonaws.com/default";

  static final UPLOAD_VIDEO_URL = "$BASE_URL/VideoUpload";

  static final SIGNUP_USER_URL = "$BASE_URL/CreateNewUser";

  static var GET_USER_BY_EMAIL_URL = "$BASE_URL/GetUserByEmail?email=";

  static var GET_USER_BY_ID_URL = "$BASE_URL/GetUserById?user_id=";

  Uri upload_video_uri = Uri.parse(UPLOAD_VIDEO_URL);

  Uri signup_user_uri = Uri.parse(SIGNUP_USER_URL);

  Future<UserObject?> getUserByEmail(String email) async {
    // Parsing GET USER bY EMAIL URL
    var NEW_GET_USER_BY_EMAIL = GET_USER_BY_EMAIL_URL + email;
    Uri user_email_uri = Uri.parse(GET_USER_BY_EMAIL_URL);

    try {
      http.Response response = await http.get(user_email_uri);
      print('\n\n ${jsonDecode(response.body)} \n\n');
      return UserObject.fromJson(jsonDecode(response.body));
    } catch (e) {
      print('\n\n Error: $e \n\n');
      return null;
    }
  }

  getUserByIdGetRequest(String userid, callback) async {
    // Parsing GET USER BY EMAIL
    var NEW_GET_USER_BY_ID_URL = GET_USER_BY_ID_URL + userid;
    Uri user_uri = Uri.parse(NEW_GET_USER_BY_ID_URL);

    try {
      http.Response response = await http.get(user_uri);
      print('\n\n ${jsonDecode(response.body)} \n\n');
      callback("success", jsonDecode(response.body));
    } catch (e) {
      callback(null);
    }
  }

  signupUserPostRequest(
      {required String email,
      required String token,
      required String name,
      required Function callback}) async {
    print('\n\n Signup User Post Request Called ==> $email $name $token \n\n');

    var bodyobj = {
      "name": name,
      "email": email,
      "sign_in_token": token,
      "gender": "",
      "age": "",
      "bio": ""
    };

    try {
      http.Response response = await http.post(
        signup_user_uri,
        body: json.encode(bodyobj),
        headers: {"Content-Type": "application/json"},
      );
      print('\n\n ${jsonDecode(response.body)} \n\n');
      callback("Success", jsonDecode(response.body));
    } catch (e) {
      callback(null);
    }
  }

  uploadVideoPostRequest(file) async {
    try {
      http.Response response = await http.get(upload_video_uri);
      print('\n\n ${jsonDecode(response.body)} \n\n');
      var urlResponse = jsonDecode(response.body);
      var bytes = _readFileByte(file);

      print(
        '\n SignUpUserPostRequest Success >>>> :: $bytes \n ${bytes.runtimeType} \n',
      );
      print('\n urlResponse: ${urlResponse["uploadURL"]}');
      print(
        '\n urlResponse type: ${urlResponse["uploadURL"].runtimeType} \n',
      );
      Uri upload_video_response_uri = Uri.parse(urlResponse["uploadURL"]);
      http.Response response2 = await http.put(
        upload_video_response_uri,
        body: await _readFileByte(file),
      );
      print('\n Response2 Success >>>> :: ${jsonDecode(response2.body)} \n');
    } catch (e) {
      print('\n\n \n\n SignUpUserPostRequest Failed >>>> ::');
      print(e);
    }
  }

// Future<String?> fetchUploadUrl() async {
//   try {
//     http.Response response = await http.get(upload_video_uri);
//     var urlResponse = jsonDecode(response.body);
//
//   } catch (e) {
//     print('\n\n \n\n SignUpUserPostRequest Failed >>>> ::');
//     print(e);
//   }
// }
//
// uploadVideo(File file, String videoUrl) async {
//   var bytes = _readFileByte(file);
//   Uri upload_video_response_uri = Uri.parse(urlResponse["uploadURL"]);
//   print("\n\n urlResponse type2: ");
//   http.Response response2 = await http.put(
//     upload_video_response_uri,
//     body: await _readFileByte(file),
//   );
//   print(
//       '\n\n Response2 Success >>>> :: ${jsonDecode(response2.body)} \n\n\n');
// }
}
