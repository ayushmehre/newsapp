import 'dart:ffi';
import 'dart:io';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  bool isLoading = false;

  var tagsList = [];
  String tag = '';

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.file(widget.file),
    );
    setState(() {
      tagsList = [];
      isLoading = false;
    });
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
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Tags'),
          content: Container(
            width: MediaQuery.of(context).size.width - 20,
            child: TextField(
              obscureText: false,
              decoration: InputDecoration(
                hintText: "Enter $title",
                hintStyle: TextStyle(fontSize: 14, color: CustomColors().grey),
                border: InputBorder.none,
                fillColor: CustomColors().fillColor,
                filled: true,
              ),
              onChanged: (val) {
                tag = val.trim().toLowerCase();
              },
            ),
          ),
          actions: [
            MaterialButton(
              onPressed: () {
                // If tag does not exist then add that tag
                print("\n\n $tag");
                if (tag.length != 0 && !(tagsList.contains(tag))) {
                  setState(() {
                    tagsList.add(tag);
                  });
                }
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Build an alert to show some errors
  Future<void> showRemoveTagDialog(String tagName) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Text('Remove Tag'),
          content: Container(
            width: MediaQuery.of(context).size.width - 20,
            child: Text("Are you sure you want to remove \"$tagName\" tag ?"),
          ),
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            MaterialButton(
              onPressed: () {
                // If tag does not exist then add that tag
                removeTag(tagName);
                Navigator.pop(context);
              },
              child: Text('Remove'),
            ),
          ],
        );
      },
    );
  }

  removeTag(String tagname) {
    setState(() {
      tagsList.remove(tagname);
    });
  }

  @override
  Widget build(BuildContext context) {
    double length = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors().red,
        title: Text("Post News Video"),
      ),
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
          _entryField("Video Title"),
          _entryField("Video Description", maxlines: 5),
          _addtagField("Tags"),
          _submitButton(length: length),
        ],
      ),
    );
  }

  Container showVideo(double length) {
    return Container(
      width: length,
      height: length,
      color: CustomColors().black,
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

  Widget _entryField(String title,
      {bool isPassword = false, int maxlines = 1}) {
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
            maxLines: null,
            minLines: maxlines,
            obscureText: isPassword,
            decoration: InputDecoration(
              hintText: "Enter $title",
              hintStyle: TextStyle(fontSize: 14, color: CustomColors().grey),
              border: InputBorder.none,
              fillColor: CustomColors().fillColor,
              filled: true,
            ),
          )
        ],
      ),
    );
  }

  List<Widget> getChipsFromTags() {
    List<Widget> chips = [];

    for (var i = 0; i < tagsList.length; i++) {
      chips.add(
        Padding(
          padding: EdgeInsets.fromLTRB(0, 8, 14, 8),
          child: InkWell(
            onTap: () {
              showRemoveTagDialog(tagsList[i]);
            },
            child: getChipWidget(tagsList[i]),
          ),
        ),
      );
    }
    return chips;
  }

  Widget getChipWidget(String text) {
    return Container(
      // width: 100,
      padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
      decoration: BoxDecoration(
        color: CustomColors().grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        // crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text),
          SizedBox(width: 5),
          Icon(FontAwesomeIcons.times, size: 12)
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
          InkWell(
            onTap: () {
              _alertDialogBuilder("Enter tag");
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
              alignment: Alignment.centerLeft,
              color: CustomColors().fillColor,
              width: MediaQuery.of(context).size.width,
              child: tagsList.length == 0
                  ? Container(
                      padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                      child: Text(
                        "Enter $title",
                        style: TextStyle(
                          fontSize: 14,
                          color: CustomColors().grey,
                        ),
                      ),
                    )
                  : Wrap(
                      children: getChipsFromTags(),
                    ),
            ),
          ),

          Container(
            alignment: Alignment.centerRight,
            child: OutlinedButton(
              style: ButtonStyle(alignment: Alignment.centerRight),
              onPressed: () {
                _alertDialogBuilder("Enter tag");
              },
              child: Container(
                width: 50,
                alignment: Alignment.center,
                child: Text(
                  "Add Tag",
                  style: TextStyle(color: CustomColors().grey, fontSize: 12),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _submitButton({double? length}) {
    return MaterialButton(
      padding: EdgeInsets.symmetric(horizontal: 0),
      onPressed: () async {
        setState(() {
          isLoading = true;
        });
        var uploadVideoResponse = await API().uploadVideoPostRequest(widget.file);
        if(uploadVideoResponse == null) {
          setState(() {
            isLoading = false;
          });
        }
      },
      child: Container(
        width: length,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.red[600],
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.shade200,
              offset: Offset(2, 4),
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Text(
          'Publish',
          style: TextStyle(
            fontSize: 20,
            color: CustomColors().white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
