import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qrious_createrapp/utils/colors.dart';
import 'package:story_view/story_view.dart';

Widget getVideoStories(BuildContext context, storyController, int likes) {
  final height = MediaQuery.of(context).size.height;
  final width = MediaQuery.of(context).size.width;
  bool isLiked = false;
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
              url: "https://media.giphy.com/media/XcA8krYsrEAYXKf4UQ/giphy.gif",
              caption: "Hello, from the other side",
              controller: storyController,
            ),
            StoryItem.pageImage(
              url: "https://media.giphy.com/media/XcA8krYsrEAYXKf4UQ/giphy.gif",
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
                likes = likes + 1;
                isLiked = true;
              },
              child: Container(
                width: width / 5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "$likes",
                      style: TextStyle(color: CustomColors().white, fontSize: 20),
                    ),
                    SizedBox(width: 4),
                    Icon(isLiked ? Icons.thumb_down: Icons.thumb_up, color: CustomColors().white),
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