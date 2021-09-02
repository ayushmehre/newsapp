import 'dart:ffi';
import 'dart:io';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qrious_createrapp/utils/api.dart';
import 'package:qrious_createrapp/utils/colors.dart';
import 'package:video_player/video_player.dart';

class AddVideoPlayer extends StatefulWidget {
  final File file;
  const AddVideoPlayer({Key? key, required this.file}) : super(key: key);

  @override
  _AddVideoPlayerState createState() => _AddVideoPlayerState();
}

class _AddVideoPlayerState extends State<AddVideoPlayer> {
  late FlickManager flickManager;
  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.file(widget.file),
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  // Build an alert to show some errors
  Future<void> _alertDialogBuilder(String title) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Tags'),
          content: Container(
            width: MediaQuery.of(context).size.width - 20,
            child: TextField(
              obscureText: false,
              decoration: InputDecoration(
                hintText: "Enter $title",
                hintStyle: TextStyle(fontSize: 14, color: grey),
                border: InputBorder.none,
                fillColor: fillColor,
                filled: true,
              ),
            ),
          ),
          actions: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text('Close Dialog'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double length = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            showVideo(length),
            // SizedBox(height: 20),
            _inputFieldsWidget(length: length),
          ],
        ),
      ),
    );
  }

  Widget _inputFieldsWidget({double? length}) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        children: <Widget>[
          _entryField("Video title"),
          _textAreaField("Video description"),
          _addtagField("Add tags"),
          _submitButton(length: length),
        ],
      ),
    );
  }

  Container showVideo(double length) {
    return Container(
      width: length,
      height: length,
      color: black,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FittedBox(
            fit: BoxFit.cover,
            child: Container(
              height: length,
              child: FlickVideoPlayer(flickManager: flickManager),
            ),
          ),
        ],
      ),
    );
  }

  Widget _entryField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(height: 10),
          TextField(
            obscureText: isPassword,
            decoration: InputDecoration(
              hintText: "Enter $title",
              hintStyle: TextStyle(fontSize: 14, color: grey),
              border: InputBorder.none,
              fillColor: fillColor,
              filled: true,
            ),
          )
        ],
      ),
    );
  }

  Widget _addtagField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width - 90,
                child: TextField(
                  obscureText: isPassword,
                  decoration: InputDecoration(
                    hintText: "Enter $title",
                    hintStyle: TextStyle(fontSize: 14, color: grey),
                    border: InputBorder.none,
                    fillColor: fillColor,
                    filled: true,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  _alertDialogBuilder("Enter tag");
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 50,
                  height: 47,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xff2872ba), Color(0xff1959a9)],
                    ),
                  ),
                  // decoration: BoxDecoration(color: blue),
                  child: Text("Add", style: TextStyle(color: white)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _textAreaField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(height: 10),
          TextField(
            obscureText: isPassword,
            maxLines: null,
            minLines: 5,
            decoration: InputDecoration(
              hintText: "Enter $title",
              hintStyle: TextStyle(fontSize: 14, color: grey),
              border: InputBorder.none,
              fillColor: fillColor,
              filled: true,
            ),
          )
        ],
      ),
    );
  }

  Widget _submitButton({double? length}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: () {
          uploadVideoPostRequest(widget.file);
        },
        child: Container(
          width: length,
          padding: EdgeInsets.symmetric(vertical: 15),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey.shade200,
                offset: Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2,
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xfffbb448), Color(0xfff7892b)],
            ),
          ),
          child: Text(
            'Login',
            style: TextStyle(fontSize: 20, color: white),
          ),
        ),
      ),
    );
  }
}
