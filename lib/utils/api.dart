import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/services.dart' show rootBundle;

import 'package:http/http.dart' as http;

const UPLOAD_VIDEO_URL =
    "https://hpe74fftu9.execute-api.ap-south-1.amazonaws.com/default/VideoUpload";

Uri upload_video_uri = Uri.parse(UPLOAD_VIDEO_URL);

const SIGNUP_USER_URL =
    "https://akugo8ysj8.execute-api.ap-south-1.amazonaws.com/dev/CreateNewUser";

Uri signup_user_uri = Uri.parse(SIGNUP_USER_URL);

Future<Uint8List> _readFileByte(File filePath) async {
  print("\n 11111: \n");
  Uint8List bytes = filePath.readAsBytesSync();
  print("\n 22222:");
  return Uint8List.view(bytes.buffer);
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
      headers: {"Content-Type": "application/json"}
    );
    print('\n\n ${jsonDecode(response.body)} \n\n');
    callback("Success", jsonDecode(response.body));
  } catch (e) {
    callback(null);
  }
}

uploadVideoPostRequest(file) async {
  // print('\n\n \n\n \n\n File Format... ${file.runtimeType()} \n\n \n\n \n\n');
  try {
    http.Response response = await http.get(upload_video_uri);
    print('\n\n ${jsonDecode(response.body)} \n\n');
    var urlResponse = jsonDecode(response.body);
    var bytes = _readFileByte(file);

    print(
        '\n\n\n SignUpUserPostRequest Success >>>> :: $bytes \n ${bytes.runtimeType} \n');
    print('\n\n \n\n urlResponse: ${urlResponse["uploadURL"]}');
    print('\n urlResponse type: ${urlResponse["uploadURL"].runtimeType} \n\n');
    Uri upload_video_response_uri = Uri.parse(urlResponse["uploadURL"]);
    print("\n\n urlResponse type2: ");
    http.Response response2 = await http.put(
      upload_video_response_uri,
      body: await _readFileByte(file),
      // body: {"bytes": _readFileByte(file)},
    );
    print(
        '\n\n Response2 Success >>>> :: ${jsonDecode(response2.body)} \n\n\n');
  } catch (e) {
    print('\n\n \n\n SignUpUserPostRequest Failed >>>> ::');
    print(e);
  }
}

uploadVideoPutRequest() async {}
