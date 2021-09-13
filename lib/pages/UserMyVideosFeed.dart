import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newsapp/models/NewsStoryObject.dart';
import 'package:newsapp/utils/api.dart';
import 'package:newsapp/utils/colors.dart';
import 'package:newsapp/widgets/user_uploaded_news_widget.dart';
import 'package:newsapp/widgets/widgets.dart';
import 'package:video_player/video_player.dart';

import 'CreateNewsStoryPage.dart';

class UserMyVideosFeed extends StatefulWidget {
  const UserMyVideosFeed({Key? key}) : super(key: key);

  @override
  _UserMyVideosFeedState createState() => _UserMyVideosFeedState();
}

class _UserMyVideosFeedState extends State<UserMyVideosFeed> {
  late bool isloading = false;
  late List<NewsStoryObject> feedList = [];

  late VideoPlayerController _controller;
  final videoInfo = FlutterVideoInfo();
  late File _file;
  final selected = ImagePicker();

  @override
  void initState() {
    super.initState();
    getHomePageStoriesFeeds();
  }

  Future getImage() async {
    final selectedImage = await selected.pickVideo(source: ImageSource.gallery);
    var a = await videoInfo.getVideoInfo(selectedImage!.path);

    setState(() {
      if (selectedImage != null) {
        _file = File(selectedImage.path);
        VideoPlayerController.file(File(selectedImage.path));

        var endDuration = (a!.duration)! / 1000 <= 60;
        var startDuration = (a.duration)! / 1000 >= 10;
        var filelength = (_file.lengthSync() / 1024 / 1024) <= 50;
        if (!startDuration) {
          showErrorDialog(
              context, "Error", "Please select file greater then 10 seconds");
          return;
        }
        if (!endDuration) {
          showErrorDialog(
              context, "Error", "Please select file less then 60 seconds");
          return;
        }
        if (!filelength) {
          showErrorDialog(
              context, "Error", "File size should not be greater then 50MB");
          return;
        }

        print('\n\n \n\n \n\n \n\n');
        print(_file);
        print('\n\n \n\n \n\n \n\n');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreateNewsStoryPage(file: _file),
            // builder: (context) => AddVideoScreen(file: _file),
          ),
        );
      } else {
        print('No image selected.');
      }
    });
  }

  getHomePageStoriesFeeds() async {
    setState(() {
      isloading = true;
    });
    Map<String, dynamic> response = await API().getUserUploadedStory("1");
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
          isloading = false;
        });
        print(feedList.toString());
      } else {
        setState(() {
          isloading = false;
        });
      }
    } else {
      setState(() {
        isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: CustomColors().white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 60),
              Container(
                margin: EdgeInsets.fromLTRB(12, 0, 0, 0),
                child: Text(
                  'User Videos',
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      fontSize: 44,
                      color: CustomColors().black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              isloading
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getImage();
        },
        backgroundColor: CustomColors().red,
        child: Icon(
          Icons.add,
          size: 40,
        ),
      ),
    );
  }
}
