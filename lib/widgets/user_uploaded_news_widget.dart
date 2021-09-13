// user_uploaded_videos_widget

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/models/NewsStoryObject.dart';
import 'package:newsapp/utils/colors.dart';

class UserUploadedVideosWidget extends StatefulWidget {
  late List<NewsStoryObject> feedList;
  UserUploadedVideosWidget(this.feedList);

  @override
  _UserUploadedVideosWidgetState createState() =>
      _UserUploadedVideosWidgetState();
}

class _UserUploadedVideosWidgetState extends State<UserUploadedVideosWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.feedList.length,
      itemBuilder: (context, index) {
        return listComponent(
          context: context,
          title: widget.feedList[index].title!.length == 0
              ? "In publishing and graphic design, Lorem ipsum is a placeholder text commonly used"
              : widget.feedList[index].title.toString(),
          likes: widget.feedList[index].likesCount.toString(),
          comments: widget.feedList[index].commentsCount.toString(),
          views: widget.feedList[index].viewCount.toString(),
          shares: widget.feedList[index].shareCount.toString(),
          index: index,
          image:widget.feedList[index].thumLink,
        );
      },
    );
  }
}

Container listComponent({
  BuildContext? context,
  String? title,
  String? likes,
  String? comments,
  String? views,
  String? shares,
  int? index,
  String? image,
}) {
  final width = MediaQuery.of(context!).size.width;
  return Container(
    padding: EdgeInsets.fromLTRB(6, 12, 6, 12),
    decoration: BoxDecoration(
      color: CustomColors().white,
      border: Border(
        top: index == 0
            ? BorderSide(color: CustomColors().bordercolor, width: 1)
            : BorderSide(color: CustomColors().bordercolor, width: 0),
        bottom: BorderSide(color: CustomColors().bordercolor, width: 1),
      ),
    ),
    // decoration: BoxDecoration(
    //   borderRadius: BorderRadius.circular(4),
    //   boxShadow: [
    //     BoxShadow(
    //       color: Color(0xffdcdcdc),
    //       offset: Offset(1, 3), //(x,y)
    //       blurRadius: 6,
    //     ),
    //   ],
    // ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Uploaded News Thumbnail
        buildUploadedNewsThumbnailWidget(image, width),
        Container(
          width: width * 7 / 10 - 48,
          padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // News Title
              buildUploadedNewsTitleWidget(title),
              SizedBox(height: 8),

              // News Views & Comments count
              buildUploadedNewsRowWidget(
                'Views: $views',
                'Comments: $comments',
                width,
              ),
              SizedBox(height: 4),

              // News Likes & Shares count
              buildUploadedNewsRowWidget(
                'Likes: $likes',
                'Shares: $shares',
                width,
              ),
            ],
          ),
        ),
        // InkWell(
        //   onTap: () {},
        //   child: Container(
        //     child: Icon(Icons.more_vert, size: 20),
        //   ),
        // ),
        buildSideMenuButton(),
      ],
    ),
  );
}

PopupMenuButton<dynamic> buildSideMenuButton() {
  return PopupMenuButton(
    icon: Icon(Icons.more_vert),
    itemBuilder: (BuildContext context) => <PopupMenuEntry>[
      const PopupMenuItem(
        child: ListTile(
          // leading: Icon(Icons.add),
          title: Text('Play'),
        ),
      ),
      const PopupMenuItem(
        child: ListTile(
          // leading: Icon(Icons.anchor),
          title: Text('Edit'),
        ),
      ),
    ],
  );
}

Container buildUploadedNewsThumbnailWidget(String? image, double width) {
  return Container(
    padding: EdgeInsets.fromLTRB(8, 8, 0, 8),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Image(
        image: NetworkImage(
          image!,
        ),
        width: width * 3 / 10 - 20,
        height: 50,
      ),
    ),
  );
}

Container buildUploadedNewsTitleWidget(String? title) {
  return Container(
    child: Text(
      title!,
      maxLines: 2,
      style: TextStyle(
        fontSize: 12,
        color: CustomColors().black,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Row buildUploadedNewsRowWidget(String? text1, String? text2, double width) {
  return Row(
    children: [
      Container(
        width: width / 6,
        child: Text(
          text1!,
          style: TextStyle(
            fontSize: 11,
            color: CustomColors().grey,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      SizedBox(width: 40),
      Container(
        width: width / 6,
        child: Text(
          text2!,
          style: TextStyle(
            fontSize: 11,
            color: CustomColors().grey,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    ],
  );
}
