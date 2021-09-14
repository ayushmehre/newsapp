import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:newsapp/models/NewsStoryObject.dart';
import 'package:newsapp/utils/colors.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/story_view.dart';

class VideoStoriesFeed extends StatefulWidget {
  final List<NewsStoryObject> newsStoryObjectList;

  VideoStoriesFeed({required this.newsStoryObjectList});

  @override
  _VideoStoriesFeedState createState() => _VideoStoriesFeedState();
}

class _VideoStoriesFeedState extends State<VideoStoriesFeed> {
  PageController _controller = PageController(initialPage: 0, keepPage: false);
  final storyController = StoryController();
  int likes = 0;
  bool isLiked = false;

  int currentPage = 0;

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      likes = 0;
      isLiked = false;
      currentPage = 0;
    });
    super.initState();
  }

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        pageSnapping: true,
        itemCount: widget.newsStoryObjectList.length,
        scrollDirection: Axis.vertical,
        onPageChanged: (index) {
          // changeVideo(index);
          setState(() {
            // _isPlaying=true;
          });
        },
        itemBuilder: (context, index) {
          return PageView(
            controller: _controller,
            children: widget.newsStoryObjectList.map((e) {
              return getVideoStories(context, e, index);
            }).toList(),
          );
        },
      ),
    );
  }

  Widget getVideoStories(
    BuildContext context,
    NewsStoryObject newsStoryData,
    int index,
  ) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final title = newsStoryData.videoLink;
    print('\n\n \n\n widget.newsStoryObjectList:> $title \n\n \n\n');
    return Column(
      children: [
        Container(
          height: height - 50,
          child: StoryView(
            storyItems: [
              // StoryItem.text(
              //   title: "${newsStoryData.videoLink}",
              //   backgroundColor: CustomColors().red,
              //   textStyle: TextStyle(
              //     fontFamily: 'Dancing',
              //     fontSize: 40,
              //   ),
              // ),
              StoryItem.pageVideo(
                newsStoryData.videoLink.toString(),
                controller: storyController,
              ),
              // StoryItem.pageImage(
              //   url: newsStoryData.videoLink.toString(),
              //   caption: title,
              //   controller: storyController,
              // ),
            ],
            onStoryShow: (s) {
              print("Showing a story ${s}");
            },
            onComplete: () {
              print("Completed a cycle");
              setState(() {
                setState(() {
                  currentPage = currentPage + 1;
                });
                _controller.jumpToPage(currentPage);
              });
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
