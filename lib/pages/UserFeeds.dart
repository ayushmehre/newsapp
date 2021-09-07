import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qrious_createrapp/utils/colors.dart';

class UserFeeds extends StatefulWidget {
  const UserFeeds({Key? key}) : super(key: key);

  @override
  _UserFeedsState createState() => _UserFeedsState();
}

class _UserFeedsState extends State<UserFeeds> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(16, 20, 16, 40),
            child: Text(
              'Trending Now',
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
