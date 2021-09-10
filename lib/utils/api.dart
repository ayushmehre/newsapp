import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/services.dart' show rootBundle;

import 'package:http/http.dart' as http;
import 'package:newsapp/models/NewsStoryObject.dart';
import 'package:newsapp/models/UserObject.dart';

Future<Uint8List> _readFileByte(File filePath) async {
  print("\n 11111: \n");
  Uint8List bytes = filePath.readAsBytesSync();
  print("\n 22222:");
  return Uint8List.view(bytes.buffer);
}

class API {
  static final BASE_URL =
      "https://jgqn3d1fng.execute-api.ap-south-1.amazonaws.com/dev";

  // static final BASE_URL =
  //     "https://jgqn3d1fng.execute-api.ap-south-1.amazonaws.com/test";
  //
  // static final BASE_URL =
  //     "https://jgqn3d1fng.execute-api.ap-south-1.amazonaws.com/prod";

  static final UPLOAD_VIDEO_URL = "$BASE_URL/videoUpload";
  static final SIGNUP_USER_URL = "$BASE_URL/createNewUser";
  static var GET_USER_BY_EMAIL_URL = "$BASE_URL/getUserByEmail?email=";
  static var GET_USER_BY_ID_URL = "$BASE_URL/getUserById?user_id=";
  static final CREATE_NEWS_STORY_URL = "$BASE_URL/createNewsStory";
  static final GET_NEWS_STORY_URL = "$BASE_URL/getNewsStories";

  static final VIDEO_URL =
      "https://newsvideosupload.s3.ap-south-1.amazonaws.com/";

  Uri upload_video_uri = Uri.parse(UPLOAD_VIDEO_URL);

  Future<UserObject?> getUserByEmail(String email) async {
    // Parsing GET USER bY EMAIL URL
    var NEW_GET_USER_BY_EMAIL = GET_USER_BY_EMAIL_URL + email;
    Uri user_email_uri = Uri.parse(NEW_GET_USER_BY_EMAIL);

    print("\n\n \n\n NEW_GET_USER_BY_EMAIL:> $NEW_GET_USER_BY_EMAIL");

    try {
      http.Response response = await http.get(user_email_uri);
      print('\n\n ${jsonDecode(response.body)} \n\n');
      print('\n\n ${(jsonDecode(response.body)['data'])} \n\n');
      UserObject userObj = UserObject.fromJson(jsonDecode(response.body)['data'][0]);
      print('\n\n \n\n userObjuserObj: ${userObj.toJson()}');
      return userObj;
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

  signupCreateNewUser({
    required String email,
    required String token,
    required String name,
    required Function callback,
  }) async {
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
      http.Response response = await sendPostRequest(SIGNUP_USER_URL, bodyobj);
      print('\n\n ${jsonDecode(response.body)} \n\n');
      callback("Success", jsonDecode(response.body));
    } catch (e) {
      callback(null);
    }
  }

  // Future uploadVideoPostRequest(file) async {
  //   try {
  //     http.Response response = await http.get(upload_video_uri);
  //     print('\n\n ${jsonDecode(response.body)} \n\n');
  //     var urlResponse = jsonDecode(response.body);
  //     var bytes = _readFileByte(file);
  //
  //     print(
  //       '\n SignUpUserPostRequest Success >>>> :: $bytes \n ${bytes.runtimeType} \n',
  //     );
  //     print(urlResponse);
  //     print('\n urlResponse: ${urlResponse["uploadURL"]}');
  //     print(
  //       '\n urlResponse type: ${urlResponse["uploadURL"].runtimeType} \n',
  //     );
  //
  //     Uri upload_video_response_uri = Uri.parse(urlResponse["uploadURL"]);
  //     http.Response response2 = await http.put(
  //       upload_video_response_uri,
  //       body: await _readFileByte(file),
  //     );
  //     print('\n Response2 Success >>>> :: ${jsonDecode(response2.body)} \n');
  //   } catch (e) {
  //     print('\n\n \n\n Response2 Failed >>>> ::');
  //     print(e);
  //   }
  // }

  Future<Map?> fetchUploadUrl() async {
    try {
      // Fetching UploadUrl
      http.Response response = await http.get(upload_video_uri);
      print('\n\n ${jsonDecode(response.body)} \n\n');

      // Upload Url Response
      var urlResponse = jsonDecode(response.body);
      print('\n urlResponse: ${urlResponse["uploadURL"]}');

      // Returning Url
      return {
        'uploadURL': urlResponse["uploadURL"],
        'filename': urlResponse["filename"]
      };
    } catch (e) {
      print('\n\n \n\n fetchUploadUrl Failed >>>> ::');
      print(e);
      return null;
    }
  }

  Future<bool> uploadVideo(String urlResponse, File file) async {
    try {
      // Converting file to Unit8List byte data
      var bytes = _readFileByte(file);
      print('\n Bytes Data ::> $bytes $urlResponse \n');

      // Upload video url parse
      Uri upload_video_response_uri = Uri.parse(urlResponse);

      // Uploading video to server
      http.Response response = await http.put(
        upload_video_response_uri,
        body: await bytes,
      );

      print('\n uploadVideo Success >>>> :: ${response.statusCode} \n');

      // Returning Response
      return (response.statusCode == 200);
    } catch (e) {
      print('\n\n \n\n uploadVideo Failed >>>> ::');
      print(e);
      return false;
    }
  }

  Future<NewsStoryObject?> createNewsStory(
      String title, String desc, String uploadURL, int userId) async {
    //TODO Ankit will continue

    var bodyobj = {
      "title": title,
      "desc": desc,
      "video_link": uploadURL,
      "user_id": userId,
    };
    try {
      http.Response response = await sendPostRequest(CREATE_NEWS_STORY_URL, bodyobj);
      // http.Response response = await http.post(create_news_story_uri);
      print('\n\n ${jsonDecode(response.body)} \n\n');
      return NewsStoryObject.fromJson(jsonDecode(response.body));
    } catch (e) {
      print('\n\n Error: $e \n\n');
      return null;
    }
    // return null;
  }

  Future<Map<String,dynamic>> getNewsStory() async {
    // Get All News Story
    Uri getNewsStory = Uri.parse(GET_NEWS_STORY_URL);
    try {
      http.Response response = await http.get(getNewsStory);
      print('\n\n ${jsonDecode(response.body)} \n\n');
      return jsonDecode(response.body);
    } catch (e) {
      print('\n\n Error: $e \n\n');
      return {};
    }
  }
}

sendPostRequest(String url, Map<String, dynamic> body) async {
  http.Response response = await http.post(
    Uri.parse(url),
    body: json.encode(body),
    headers: {"Content-Type": "application/json"},
  );
  return response;
}
