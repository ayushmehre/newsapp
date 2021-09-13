import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newsapp/models/NewsStoryObject.dart';
import 'package:newsapp/utils/api.dart';
import 'package:newsapp/utils/colors.dart';
import 'package:newsapp/widgets/news_list_widget.dart';
import 'package:newsapp/widgets/widgets.dart';

class UserFeeds extends StatefulWidget {
  const UserFeeds({Key? key}) : super(key: key);

  @override
  _UserFeedsState createState() => _UserFeedsState();
}

class _UserFeedsState extends State<UserFeeds> {
  late bool boolfeedsload = false;
  late List<NewsStoryObject> feedList = [];

  @override
  void initState() {
    super.initState();
    getHomePageStoriesFeeds();
  }

  getHomePageStoriesFeeds() async {
    Map<String, dynamic> response = await API().getNewsStory();
    if (!response.isEmpty) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors().white,
      appBar: AppBar(
        toolbarHeight: 4,
        backgroundColor: CustomColors().white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(16, 20, 0, 16),
              child: Text(
                'For You',
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    fontSize: 44,
                    color: CustomColors().black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            boolfeedsload
                ? Container(
                    child: feedList.length == 0
                        ? Container(
                            child: Center(child: Text("Error")),
                          )
                        : Container(
                            height: MediaQuery.of(context).size.height - 180,
                            child: NewsListWidget(
                              feedList,
                              showNumber: false,
                            ),
                          ),
                  )
                : Container(
                    height: MediaQuery.of(context).size.height / 1.4,
                    child: customProgressIndicator(),
                  )
            // for (var i = 0; i < 10; i++)
            //   listComponent(
            //     index: (i + 1).toString(),
            //     context: context,
            //     title: 'Taliban takes control over Afghanistan',
            //     info:
            //         "Google Fonts provides a wide range of fonts that can be used to improve the fonts of the User Interface",
            //     comments: "1024",
            //     views: "100K",
            //     image:
            //         "https://images.unsplash.com/photo-1628191080740-dad84f3c993c?ixid=MnwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=750&q=80",
            //   ),
          ],
        ),
      ),
    );
  }
}
