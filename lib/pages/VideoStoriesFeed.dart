import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/utils/colors.dart';
import 'package:newsapp/widgets/get_videos_stories.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/story_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class VideoStoriesFeed extends StatefulWidget {
  @override
  _VideoStoriesFeedState createState() => _VideoStoriesFeedState();
}

class _VideoStoriesFeedState extends State<VideoStoriesFeed> {
  final storyController = StoryController();
  int likes = 0;
  bool isLiked = false;

  @override
  void initState() {
    // TODO: implement initState
    likes = 0;
    isLiked = false;
    super.initState();
  }

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: PageView.builder(
        itemCount: 10,
        scrollDirection: Axis.vertical,
        onPageChanged: (index) {
          // changeVideo(index);
          setState(() {
            // _isPlaying=true;
          });
        },
        itemBuilder: (context, index) {
          return Container(
            child: getVideoStories(context),
          );
        },
      ),
    );
  }

  Widget getVideoStories(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          height: height - 50,
          child: StoryView(
            storyItems: [
              StoryItem.text(
                title:
                    "I guess you'd love to see more of our food. That's great.",
                backgroundColor: CustomColors().black,
              ),
              StoryItem.text(
                title: "Nice!\n\nTap to continue.",
                backgroundColor: CustomColors().red ?? Colors.red,
                textStyle: TextStyle(
                  fontFamily: 'Dancing',
                  fontSize: 40,
                ),
              ),
              StoryItem.pageImage(
                url:
                    "https://image.ibb.co/cU4WGx/Omotuo-Groundnut-Soup-braperucci-com-1.jpg",
                caption: "Still sampling",
                controller: storyController,
              ),
              StoryItem.pageImage(
                url: "https://media.giphy.com/media/5GoVLqeAOo6PK/giphy.gif",
                caption: "Working with gifs",
                controller: storyController,
                shown: false,
              ),
              StoryItem.pageImage(
                url:
                    "https://media.giphy.com/media/XcA8krYsrEAYXKf4UQ/giphy.gif",
                caption: "Hello, from the other side",
                controller: storyController,
              ),
              StoryItem.pageImage(
                url:
                    "https://media.giphy.com/media/XcA8krYsrEAYXKf4UQ/giphy.gif",
                caption: "Hello, from the other side2",
                controller: storyController,
              ),
            ],
            onStoryShow: (s) {
              print("Showing a story");
            },
            onComplete: () {
              print("Completed a cycle");
            },
            progressPosition: ProgressPosition.top,
            repeat: false,
            controller: storyController,
          ),
        ),
        Container(
          height: 50,
          color: CustomColors().black,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    if (!isLiked) {
                      likes = likes + 1;
                      isLiked = true;
                    } else {
                      likes = likes - 1;
                      isLiked = false;
                    }
                  });
                },
                child: Container(
                  width: width / 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "$likes",
                        style: TextStyle(
                          color: CustomColors().white,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(width: 2),
                      Icon(
                        Icons.thumb_up,
                        color:
                            isLiked ? CustomColors().red : CustomColors().white,
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  storyController.pause();
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                        height: 400,
                        child: Center(
                          child: Text('Comments'),
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  width: width / 5,
                  child: Icon(Icons.chat, color: CustomColors().white),
                ),
              ),
              Container(
                width: width / 5,
                child: Icon(Icons.share, color: CustomColors().white),
              ),
              Container(
                width: width / 5,
                child: Icon(
                  FontAwesomeIcons.whatsapp,
                  color: CustomColors().white,
                ),
              ),
              InkWell(
                onTap: () {
                  storyController.pause();
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                        height: 400,
                        child: Center(
                          child: Text('Show More'),
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  width: width / 5,
                  child: Icon(Icons.more_vert, color: CustomColors().white),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
