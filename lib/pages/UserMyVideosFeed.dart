import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newsapp/models/NewsStoryObject.dart';
import 'package:newsapp/utils/api.dart';
import 'package:newsapp/utils/colors.dart';
import 'package:newsapp/widgets/user_uploaded_news_widget.dart';
import 'package:newsapp/widgets/widgets.dart';

class UserMyVideosFeed extends StatefulWidget {
  const UserMyVideosFeed({Key? key}) : super(key: key);

  @override
  _UserMyVideosFeedState createState() => _UserMyVideosFeedState();
}

class _UserMyVideosFeedState extends State<UserMyVideosFeed> {
  late bool isloading = false;
  late List<NewsStoryObject> feedList = [];

  @override
  void initState() {
    super.initState();
    getHomePageStoriesFeeds();
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
                  : Container(
                      height: MediaQuery.of(context).size.height,
                      child: UserUploadedVideosWidget(feedList),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
