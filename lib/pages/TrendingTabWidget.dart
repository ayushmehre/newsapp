import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newsapp/models/NewsStoryObject.dart';
import 'package:newsapp/pages/CreateNewsStoryPage.dart';
import 'package:newsapp/utils/UserUtils.dart';
import 'package:newsapp/utils/api.dart';
import 'package:newsapp/utils/colors.dart';
import 'package:newsapp/widgets/ShimmerListView.dart';
import 'package:newsapp/widgets/news_list_widget.dart';
import 'package:newsapp/widgets/widgets.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';

class TrendingTabWidget extends StatefulWidget {
  const TrendingTabWidget({Key? key}) : super(key: key);

  @override
  _TrendingTabWidgetState createState() => _TrendingTabWidgetState();
}

class _TrendingTabWidgetState extends State<TrendingTabWidget> {
  late VideoPlayerController _controller;
  final videoInfo = FlutterVideoInfo();
  late File _file;
  final selected = ImagePicker();
  late bool boolfeedsload = false;
  late List<NewsStoryObject> feedList = [];

  bool errorOccurred = false;

  bool isCreator = false;

  @override
  void initState() {
    super.initState();

    checkForCreator();

    try {
      getHomePageStoriesFeeds();
    } catch (e) {
      setState(() {
        errorOccurred = true;
      });
    }
  }

  void checkForCreator() async {
    setState(() async {
      isCreator = (await UserUtils.getCurrentUser()).iscreator ?? false;
    });
  }

  getHomePageStoriesFeeds() async {
    Map<String, dynamic> response = await API().getNewsStory();
    if (response.isNotEmpty) {
      if (response["success"]) {
        List<NewsStoryObject> tmpList = [];
        for (var dctData in response["data"]) {
          NewsStoryObject feedObj = NewsStoryObject.fromJson(dctData);
          tmpList.add(feedObj);
        }
        setState(() {
          feedList = tmpList;
          boolfeedsload = true;
        });
        print(feedList.toString());
      } else {
        setState(() {
          boolfeedsload = true;
        });
      }
    } else {
      setState(() {
        boolfeedsload = true;
      });
    }
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

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: CustomColors().white,
      appBar: buildAppBar(),
      body: errorOccurred
          ? Center(
              child: Text("Something went wrong"),
            )
          : buildSingleChildScrollView(height, context),
      floatingActionButton: isCreator ? buildFloatingActionButton() : null,
    );
  }

  FloatingActionButton buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        getImage();
      },
      backgroundColor: CustomColors().red,
      child: Icon(
        Icons.add,
        size: 40,
      ),
    );
  }

  SingleChildScrollView buildSingleChildScrollView(
      double height, BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 0, 16),
            child: buildTitle(),
          ),
          boolfeedsload
              ? container(height)
              : Shimmer.fromColors(
                  baseColor: Colors.grey.withOpacity(0.3),
                  highlightColor: Colors.grey.withOpacity(0.1),
                  enabled: true,
                  child: ShimmerListView()),
        ],
      ),
    );
  }

  Widget container(double height) {
    return feedList.length == 0
        ? Container(
            height: height / 1.4,
            child: Center(child: Text("No Stories Found")),
          )
        : newsListWidget();
  }

  NewsListWidget newsListWidget() {
    return NewsListWidget(
      feedList,
      showNumber: true,
      scrollPhysics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      toolbarHeight: 4,
      backgroundColor: CustomColors().white,
      elevation: 0,
    );
  }

  Text buildTitle() {
    return Text(
      'Trending Now',
      style: GoogleFonts.roboto(
        textStyle: TextStyle(
          fontSize: 44,
          color: CustomColors().black,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
