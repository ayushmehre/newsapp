import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newsapp/models/NewsStoryObject.dart';
import 'package:newsapp/pages/VideoStoriesFeed.dart';
import 'package:newsapp/utils/colors.dart';

class NewsStoryItemWidget extends StatefulWidget {
  NewsStoryObject newsStoryObject;
  List<NewsStoryObject> newsStoryObjectList;
  int index;
  bool showNumber;

  NewsStoryItemWidget(
    this.newsStoryObject, {
    this.index = 0,
    required this.newsStoryObjectList,
    this.showNumber = false,
  });

  @override
  _NewsStoryItemWidgetState createState() => _NewsStoryItemWidgetState();
}

class _NewsStoryItemWidgetState extends State<NewsStoryItemWidget> {
  String image =
      "https://images.unsplash.com/photo-1628191080740-dad84f3c993c?ixid=MnwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=750&q=80";

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        InkWell(
          onTap: () {
            List<NewsStoryObject> mylist = [];
            List<NewsStoryObject> mylist2 = [];
            for (NewsStoryObject temp in widget.newsStoryObjectList) {
              if (widget.newsStoryObject.storyId == temp.storyId) {
                mylist.add(temp);
              } else {
                mylist2.add(temp);
              }
            }
            mylist.addAll(mylist2);

            // for (NewsStoryObject temp in widget.newsStoryObjectList) {
            //   if (widget.newsStoryObject.storyId != temp.storyId) {
            //     mylist.add(temp);
            //   }
            // }

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VideoStoriesFeed(
                  newsStoryObjectList: mylist,
                ),
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.fromLTRB(8, 0, 0, 0),
            padding: EdgeInsets.fromLTRB(6, 20, 0, 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: widget.showNumber,
                  child: Container(
                    alignment: Alignment.center,
                    width: 34,
                    child: Text(
                      (widget.index + 1).toString(),
                      style: TextStyle(
                        fontSize: 65,
                        color: CustomColors().black,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: widget.showNumber ? width - 55 : width - 38,
                  child: Column(
                    children: [
                      buildImage(),
                      Container(
                        padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildTitle(),
                            SizedBox(height: 8),
                            buildInfo(),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Text buildInfo() {
    return Text(
      widget.newsStoryObject.descption.toString(),
      maxLines: 2,
      style: GoogleFonts.abel(
        textStyle: TextStyle(
          fontSize: 16,
          color: CustomColors().black,
          fontWeight: FontWeight.w400,
          height: 1.1,
        ),
      ),
    );
  }

  Container buildTitle() {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        widget.newsStoryObject.title.toString(),
        maxLines: 2,
        style: GoogleFonts.roboto(
          textStyle: TextStyle(
            fontSize: 26,
            color: CustomColors().black,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  Container buildImage() {
    print(widget.newsStoryObject.thumLink);
    var image2 = widget.newsStoryObject.thumLink != null
        ? widget.newsStoryObject.thumLink.toString()
        : image;
    return Container(
      padding: EdgeInsets.fromLTRB(8, 8, 0, 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image(
          image: NetworkImage(image2.toString()),
          width: double.infinity,
          height: 250,
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}
