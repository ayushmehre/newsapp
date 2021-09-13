import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

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
  static final GET_USER_UPLOADED_NEWS = "$BASE_URL/getNewsStoriesByUser?id=";

  static var GET_CATEGORIES = "$BASE_URL/getCategories";

  static final S3_UPLOAD_URL =
      "https://newsvideosupload.s3.ap-south-1.amazonaws.com/";

  Uri upload_video_uri = Uri.parse(UPLOAD_VIDEO_URL);

  Uri categories = Uri.parse(GET_CATEGORIES);

  Future<UserObject?> getUserByEmail(String email) async {
    // Parsing GET USER bY EMAIL URL
    var NEW_GET_USER_BY_EMAIL = GET_USER_BY_EMAIL_URL + email;
    Uri user_email_uri = Uri.parse(NEW_GET_USER_BY_EMAIL);

    print("\n\n \n\n NEW_GET_USER_BY_EMAIL:> $NEW_GET_USER_BY_EMAIL");

    try {
      http.Response response = await http.get(user_email_uri);
      print('\n\n ${jsonDecode(response.body)} \n\n');
      print('\n\n ${(jsonDecode(response.body)['data'])} \n\n');
      UserObject userObj =
          UserObject.fromJson(jsonDecode(response.body)['data'][0]);
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

  Future<Map?> fetchUploadUrl() async {
    try {
      // Fetching UploadUrl
      http.Response response = await http.get(upload_video_uri);
      print('\n\n ${jsonDecode(response.body)} \n\n');

      // Upload Url Response
      var urlResponse = jsonDecode(response.body);
      print('\n urlResponse: ${urlResponse["video_url"]}');

      // Returning Url
      return urlResponse;
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

  Future<bool> uploadImage(String urlResponse, File file) async {
    try {
      // Converting file to Unit8List byte data
      var bytes = _readFileByte(file);
      print('\n Bytes Data ::> $bytes $urlResponse \n');

      // Upload video url parse
      Uri upload_image_response_uri = Uri.parse(urlResponse);

      // Uploading video to server
      http.Response response = await http.put(
        upload_image_response_uri,
        body: await bytes,
      );

      print('\n uploadImage Success >>>> :: ${response.statusCode} \n');

      // Returning Response
      return (response.statusCode == 200);
    } catch (e) {
      print('\n\n \n\n uploadImage Failed >>>> ::');
      print(e);
      return false;
    }
  }

  Future<NewsStoryObject?> createNewsStory(
    String title,
    String desc,
    String uploadURL,
    String imageuploadURL,
    int userId,
  ) async {
    var bodyobj = {
      "title": title,
      "desc": desc,
      "video_link": uploadURL,
      "thum_link": imageuploadURL,
      "user_id": userId,
    };
    try {
      http.Response response = await sendPostRequest(
        CREATE_NEWS_STORY_URL,
        bodyobj,
      );
      print('\n\n ${jsonDecode(response.body)} \n\n');
      return NewsStoryObject.fromJson(jsonDecode(response.body));
    } catch (e) {
      print('\n\n Error: $e \n\n');
      return null;
    }
  }

  Future<Map<String, dynamic>> getNewsStory() async {
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

  Future<Map<String, dynamic>> getUserUploadedStory(String userid) async {
    // Get All News Story
    var NEW_GET_USER_UPLOADED_NEWS = GET_USER_UPLOADED_NEWS + userid;
    print('\n\n NEW_GET_USER_UPLOADED_NEWS :> $NEW_GET_USER_UPLOADED_NEWS');
    Uri getNewsStory = Uri.parse(NEW_GET_USER_UPLOADED_NEWS);
    try {
      http.Response response = await http.get(getNewsStory);
      print('\n\n ${jsonDecode(response.body)} \n\n');
      return jsonDecode(response.body);
    } catch (e) {
      print('\n\n Error: $e \n\n');
      return {};
    }
  }

  getCategories(callback) async {
    try {
      http.Response response = await http.get(categories);
      print('\n\n ${jsonDecode(response.body)} \n\n');
      callback("success", jsonDecode(response.body));
    } catch (e) {
      callback(null);
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
