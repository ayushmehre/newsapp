import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newsapp/models/NewsStoryObject.dart';
import 'package:newsapp/models/UserObject.dart';
import 'package:newsapp/utils/api.dart';
import 'package:newsapp/utils/colors.dart';
import 'package:newsapp/utils/utils.dart';
import 'package:newsapp/widgets/user_uploaded_news_widget.dart';
import 'package:newsapp/widgets/widgets.dart';
import 'package:video_player/video_player.dart';

import 'CreateNewsStoryPage.dart';

class MyVideosPage extends StatefulWidget {
  final UserObject? userObject;

  MyVideosPage(this.userObject);

  @override
  _MyVideosPageState createState() => _MyVideosPageState();
}

class _MyVideosPageState extends State<MyVideosPage> {
  late bool isLoading = false;
  late List<NewsStoryObject> feedList = [];

  late VideoPlayerController _controller;
  final videoInfo = FlutterVideoInfo();
  late File _file;
  final selected = ImagePicker();

  @override
  void initState() {
    super.initState();
    getUserStoriesFeeds();
  }

  // Future getImage() async {
  //   final selectedImage = await selected.pickVideo(source: ImageSource.gallery);
  //   var a = await videoInfo.getVideoInfo(selectedImage!.path);
  //
  //   setState(() {
  //     if (selectedImage != null) {
  //       _file = File(selectedImage.path);
  //       VideoPlayerController.file(File(selectedImage.path));
  //
  //       var endDuration = (a!.duration)! / 1000 <= 60;
  //       var startDuration = (a.duration)! / 1000 >= 10;
  //       var filelength = (_file.lengthSync() / 1024 / 1024) <= 50;
  //       if (!startDuration) {
  //         showErrorDialog(
  //             context, "Error", "Please select file greater then 10 seconds");
  //         return;
  //       }
  //       if (!endDuration) {
  //         showErrorDialog(
  //             context, "Error", "Please select file less then 60 seconds");
  //         return;
  //       }
  //       if (!filelength) {
  //         showErrorDialog(
  //             context, "Error", "File size should not be greater then 50MB");
  //         return;
  //       }
  //
  //       print('\n\n \n\n \n\n \n\n');
  //       print(_file);
  //       print('\n\n \n\n \n\n \n\n');
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => CreateNewsStoryPage(file: _file),
  //           // builder: (context) => AddVideoScreen(file: _file),
  //         ),
  //       );
  //     } else {
  //       print('No image selected.');
  //     }
  //   });
  // }

  getUserStoriesFeeds() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> response =
        await API().getUserUploadedStory(widget.userObject!.userId.toString());
    print(response);
    if (response.length != 0) {
      if (response["success"]) {
        List<NewsStoryObject> tmpList = [];
        for (var dctData in response["data"]) {
          NewsStoryObject feedObj = NewsStoryObject.fromJson(dctData);
          tmpList.add(feedObj);
        }
        setState(() {
          feedList = tmpList;
          isLoading = false;
        });
        print(feedList.toString());
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildSingleChildScrollView(context),
      floatingActionButton: buildFloatingActionButton(),
    );
  }

  FloatingActionButton buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () async {
        File? selectedFile = await pickVideo(context);
        setState(() {
          if (selectedFile != null) {
            _file = selectedFile;
            navigateToCreateScreen(_file);
          }
        });
      },
      backgroundColor: CustomColors().red,
      child: Icon(
        Icons.add,
        size: 40,
      ),
    );
  }

  SingleChildScrollView buildSingleChildScrollView(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: CustomColors().white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 60),
            Container(
              margin: EdgeInsets.fromLTRB(12, 0, 0, 0),
              child: Text(
                'Uploaded Videos',
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    fontSize: 44,
                    color: CustomColors().black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            isLoading
                ? Container(
                    height: MediaQuery.of(context).size.height / 1.4,
                    child: customProgressIndicator(),
                  )
                : feedList.length == 0
                    ? Container(
                        height: MediaQuery.of(context).size.height / 1.2,
                        child: Center(
                          child: Text("No videos uploaded yet"),
                        ),
                      )
                    : Container(
                        height: MediaQuery.of(context).size.height,
                        child: UserUploadedVideosWidget(feedList),
                      ),
          ],
        ),
      ),
    );
  }

  void navigateToCreateScreen(File _file) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateNewsStoryPage(file: _file),
      ),
    );
  }
}
