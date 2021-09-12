import 'package:flutter/cupertino.dart';
import 'package:newsapp/models/NewsStoryObject.dart';
import 'package:newsapp/utils/colors.dart';

import 'news_story_widget.dart';

class NewsListWidget extends StatefulWidget {
  late List<NewsStoryObject> feedList;
  bool showNumber;
  NewsListWidget(this.feedList, {this.showNumber = false});

  @override
  _NewsListWidgetState createState() => _NewsListWidgetState();
}

class _NewsListWidgetState extends State<NewsListWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
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
        return NewsStoryItemWidget(
          widget.feedList[index],
          newsStoryObjectList: widget.feedList,
          index: index,
          showNumber: widget.showNumber,
        );
      },
    );
  }
}
