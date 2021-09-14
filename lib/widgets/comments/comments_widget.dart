import 'package:comment_tree/data/comment.dart';
import 'package:comment_tree/widgets/comment_tree_widget.dart';
import 'package:comment_tree/widgets/tree_theme_data.dart';
import 'package:flutter/material.dart';

Widget commentBodyWidget() {
  return Container(
    child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CommentTreeWidget<Comment, Comment>(
            Comment(
              avatar: 'null',
              userName: 'Ankit Jain',
              content: 'felangel made felangel/cubit_and_beyond public ',
            ),
            [
              Comment(
                avatar: 'null',
                userName: 'Aman Yadav',
                content: 'A Dart template generator which helps teams',
              ),
              Comment(
                avatar: 'null',
                userName: 'Umang Jain',
                content: 'A Dart template generator which helps teams',
              ),
            ],
            treeThemeData: TreeThemeData(lineColor: Colors.white),
            avatarRoot: (context, data) => PreferredSize(
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey,
                backgroundImage: AssetImage('assets/avatar_2.png'),
              ),
              preferredSize: Size.fromRadius(18),
            ),
            avatarChild: (context, data) => PreferredSize(
              child: CircleAvatar(
                radius: 12,
                backgroundColor: Colors.grey,
                backgroundImage: AssetImage('assets/avatar_1.png'),
              ),
              preferredSize: Size.fromRadius(12),
            ),
            contentChild: (context, data) {
              print("\n\n \n\n comment data:> ${data.userName}");
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.userName.toString(),
                          style: Theme.of(context).textTheme.caption?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${data.content}',
                          style: Theme.of(context).textTheme.caption?.copyWith(
                                fontWeight: FontWeight.w300,
                                color: Colors.black,
                              ),
                        ),
                      ],
                    ),
                  ),
                  DefaultTextStyle(
                    style: Theme.of(context).textTheme.caption!.copyWith(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.bold,
                        ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          SizedBox(width: 8),
                          Text('Like'),
                          SizedBox(width: 24),
                          Text('Reply'),
                        ],
                      ),
                    ),
                  )
                ],
              );
            },
            contentRoot: (context, data) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Aman Yadav',
                          style: Theme.of(context).textTheme.caption!.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${data.content}',
                          style: Theme.of(context).textTheme.caption!.copyWith(
                                fontWeight: FontWeight.w300,
                                color: Colors.black,
                              ),
                        ),
                      ],
                    ),
                  ),
                  DefaultTextStyle(
                    style: Theme.of(context).textTheme.caption!.copyWith(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.bold,
                        ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          SizedBox(width: 8),
                          Text('Like'),
                          SizedBox(width: 24),
                          Text('Reply'),
                        ],
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    ),
  );
}
