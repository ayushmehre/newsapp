import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newsapp/utils/colors.dart';

class UserFeeds extends StatefulWidget {
  const UserFeeds({Key? key}) : super(key: key);

  @override
  _UserFeedsState createState() => _UserFeedsState();
}

class _UserFeedsState extends State<UserFeeds> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors().white,
      appBar: AppBar(
        toolbarHeight: 4,
        backgroundColor: CustomColors().white,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(16, 20, 16, 40),
            child: Text(
              'User Feeds',
              style: GoogleFonts.roboto(
                textStyle: TextStyle(
                  fontSize: 44,
                  color: CustomColors().black,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Center(
            child: Text("For You"),
          ),
        ],
      ),
    );
  }
}
