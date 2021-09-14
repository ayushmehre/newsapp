import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newsapp/models/NewsStoryObject.dart';
import 'package:newsapp/utils/api.dart';
import 'package:newsapp/utils/colors.dart';
import 'package:newsapp/widgets/ShimmerListView.dart';
import 'package:newsapp/widgets/news_list_widget.dart';
import 'package:newsapp/widgets/widgets.dart';
import 'package:shimmer/shimmer.dart';

class CategoryNewListScreen extends StatefulWidget {
  final String categoryName;

  const CategoryNewListScreen({Key? key, required this.categoryName})
      : super(key: key);

  @override
  _CategoryNewListScreenState createState() => _CategoryNewListScreenState();
}

class _CategoryNewListScreenState extends State<CategoryNewListScreen> {
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
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Icon(FontAwesomeIcons.chevronLeft, size: 30),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(16, 20, 0, 16),
                    child: Text(
                      widget.categoryName,
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          fontSize: 44,
                          color: CustomColors().black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
                : Shimmer.fromColors(
                    baseColor: Colors.grey.withOpacity(0.3),
                    highlightColor: Colors.grey.withOpacity(0.1),
                    enabled: true,
                    child: ShimmerListView())
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
