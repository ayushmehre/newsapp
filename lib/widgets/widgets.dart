import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newsapp/utils/colors.dart';

// Build an alert to show some errors
Future<void> showErrorDialog(BuildContext context, String title, String error) async {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Container(
          width: MediaQuery.of(context).size.width - 20,
          child: Text(error),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}

Widget getTitleWidget(double fs, Color? color) {
  return RichText(
    textAlign: TextAlign.center,
    text: TextSpan(
      text: 'Pocket',
      style: GoogleFonts.roboto(
        fontSize: fs,
        fontWeight: FontWeight.w900,
        color: color ?? Colors.red[600],
      ),
      children: [
        TextSpan(
          text: 'Feed',
          style: GoogleFonts.roboto(
            fontSize: fs,
            fontWeight: FontWeight.w900,
            color: CustomColors().black,
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
