import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qrious_createrapp/utils/colors.dart';

Widget titleWidget(double fs, String text1, String text2, Color color) {
  return RichText(
    textAlign: TextAlign.center,
    text: TextSpan(
      text: text1,
      style: GoogleFonts.roboto(
        fontSize: fs,
        fontWeight: FontWeight.w900,
        color: color,
      ),
      children: [
        TextSpan(
          text: text2,
          style: GoogleFonts.roboto(
            fontSize: fs,
            fontWeight: FontWeight.w900,
            color: black,
          ),
        ),
      ],
    ),
  );
}

Text subTitleWidget(String text, double fs, Color color) {
  return Text(
    text,
    style: TextStyle(
      fontSize: fs,
      color: color,
    ),
  );
}