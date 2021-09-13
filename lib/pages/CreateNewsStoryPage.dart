import 'dart:io';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:newsapp/models/NewsStoryObject.dart';
import 'package:newsapp/utils/UserUtils.dart';
import 'package:newsapp/utils/api.dart';
import 'package:newsapp/utils/colors.dart';
import 'package:newsapp/utils/utils.dart';
import 'package:newsapp/widgets/widgets.dart';
import 'package:video_player/video_player.dart';

class CreateNewsStoryPage extends StatefulWidget {
  final File file;

  const CreateNewsStoryPage({Key? key, required this.file}) : super(key: key);

  @override
  _CreateNewsStoryPageState createState() => _CreateNewsStoryPageState();
}

class _CreateNewsStoryPageState extends State<CreateNewsStoryPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController videoName, videoDesc;

  late FlickManager flickManager;
  bool isLoading = false;
  bool tagserror = false;

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
      tagserror = false;
    });
    videoName = TextEditingController();
    videoDesc = TextEditingController();
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  // Build an alert to show some errors
  Future<void> addTagsDialogBuilder(String title) async {
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
                FocusScope.of(context).unfocus();
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
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: CustomColors().black),
                  SizedBox(height: 16),
                  Text('Uploading...', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 6),
                  Text("It may take a while"),
                  SizedBox(height: 6),
                  Text("(1-2 minutes)"),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    showVideo(length),
                    _inputFieldsWidget(length: length),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _inputFieldsWidget({double? length}) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        children: <Widget>[
          _customInputField(
            "Video Title",
            validator: (val) {
              if (val!.isEmpty) {
                return "Video title can\'t be empty";
              } else {
                return null;
              }
            },
            controller: videoName,
          ),
          _customInputField(
            "Video Description",
            maxlines: 5,
            validator: (val) {
              if (val!.isEmpty) {
                return "Video description can\'t be empty";
              } else {
                return null;
              }
            },
            controller: videoDesc,
          ),
          _addtagField("Tags"),
          _submitButton(length: length),
        ],
      ),
    );
  }

  Widget _customInputField(
    String title, {
    bool isPassword = false,
    int maxlines = 1,
    String? Function(String?)? validator,
    TextEditingController? controller,
  }) {
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
          TextFormField(
            maxLines: null,
            minLines: maxlines,
            obscureText: isPassword,
            validator: validator,
            controller: controller,
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
              addTagsDialogBuilder("Enter tag");
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
          tagserror
              ? Container(
                  margin: EdgeInsets.only(top: 5),
                  child: Text(
                    "Please select atlease 3 tags",
                    style: TextStyle(fontSize: 12, color: CustomColors().red),
                  ),
                )
              : Container(),
          Container(
            alignment: Alignment.centerRight,
            child: OutlinedButton(
              style: ButtonStyle(alignment: Alignment.centerRight),
              onPressed: () {
                setState(() {
                  tagserror = false;
                });
                addTagsDialogBuilder("Enter tag");
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

  publishVideoToServer() async {
    //Validating inputs
    if (_formKey.currentState!.validate()) {
      if (tagsList.length < 3) {
        setState(() {
          tagserror = true;
        });
        return;
      }
      setState(() {
        isLoading = true;
      });

      //Starting to upload
      var response = await API().fetchUploadUrl();
      print(response);
      if (response != null) {
        var video_url = response['video_url'];
        var video_name = response['video_name'];
        var image_url = response['image_url'];
        var image_name = response['image_name'];

        var videoUploadSuccess = await API().uploadVideo(
          video_url,
          widget.file,
        );
        var getvideourl = API.S3_UPLOAD_URL + video_name;
        var getimageurl = API.S3_UPLOAD_URL + image_name;
        if (videoUploadSuccess) {
          try {
            // Getting Image Thumbnail
            File imageFileData = await getVideoThumbnail(getvideourl);

            // Uploading Image
            var imageUploadSuccess = await API().uploadImage(
              image_url,
              imageFileData,
            );

            if (imageUploadSuccess) {
              // Getting Current User
              var currentUser = await UserUtils.getCurrentUser();
              print("\n\n currentUsercurrentUser: ${currentUser.userId}");

              // Creating News Story
              NewsStoryObject? newsStoryObject = await API().createNewsStory(
                videoName.text.toString(),
                videoDesc.text.toString(),
                getvideourl,
                getimageurl,
                currentUser.userId ?? 0,
              );
              setState(() {
                isLoading = false;
              });
              if (newsStoryObject != null) {
                showErrorDialog(
                  context,
                  "Success",
                  "Your video is uploaded successfully",
                );
                Navigator.pop(context);
              }
            } else {
              setState(() {
                isLoading = false;
              });
            }
          } catch (e) {
            print('\n\n \n\n currentUser Failed >>>> ::');
            print(e);
            setState(() {
              isLoading = false;
            });
          }
        } else {
          setState(() {
            isLoading = false;
          });
        }
      }
    }
  }

  Widget _submitButton({double? length}) {
    return MaterialButton(
      padding: EdgeInsets.symmetric(horizontal: 0),
      onPressed: () async {
        await publishVideoToServer();
      },
      child: Container(
        width: length,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: CustomColors().red,
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
