import 'package:flutter/cupertino.dart';
import 'package:newsapp/models/NewsStoryObject.dart';
import 'package:newsapp/utils/colors.dart';
import 'package:newsapp/widgets/scroll_listener.dart';
import 'package:newsapp/tabs/bottom_nav.dart';

import 'news_story_widget.dart';
// import 'newsstory_widget.dart';

class NewsListWidget extends StatefulWidget {
  late List<NewsStoryObject> feedList;
  bool showNumber;

  NewsListWidget(this.feedList, {this.showNumber = false});

  @override
  _NewsListWidgetState createState() => _NewsListWidgetState();
}

class _NewsListWidgetState extends State<NewsListWidget> {
  late final ScrollController _controller;
  late final ScrollListener _model2;

  @override
  void initState() {
    _controller = ScrollController();
    _model2 = ScrollListener.initialise(_controller);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        controller: _controller,
        separatorBuilder: (context, num) {
          return Container(
            decoration: BoxDecoration(
              color: CustomColors().white,
              border: Border(
                bottom: BorderSide(color: CustomColors().bordercolor, width: 1),
              ),
            ),
          );
        },
        itemCount: widget.feedList.length,
        itemBuilder: (context, index) {
          return NewsStoryItemWidget(widget.feedList[index],
              index: index, showNumber: widget.showNumber, newsStoryObjectList: [],);
        });
  }
}
