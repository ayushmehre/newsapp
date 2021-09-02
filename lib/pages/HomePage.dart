import 'dart:io';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qrious_createrapp/dummy/add_video_player.dart';
import 'package:qrious_createrapp/pages/AddVideo.dart';
import 'package:qrious_createrapp/pages/LoginPage.dart';
import 'package:qrious_createrapp/pages/SingleFeed.dart';
import 'package:qrious_createrapp/utils/colors.dart';
import 'package:video_player/video_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late VideoPlayerController _controller;
  late File _file;
  final selected = ImagePicker();

  Future getImage() async {
    final selectedImage = await selected.pickVideo(source: ImageSource.gallery);

    setState(() {
      if (selectedImage != null) {
        _file = File(selectedImage.path);
        VideoPlayerController.file(File(selectedImage.path));
        print('\n\n \n\n \n\n \n\n');
        print(_file);
        print('\n\n \n\n \n\n \n\n');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddVideoPlayer(file: _file),
            // builder: (context) => AddVideoScreen(file: _file),
          ),
        );
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        toolbarHeight: 4,
        backgroundColor: white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(16, 20, 0, 16),
              child: Text(
                'Trending Now',
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    fontSize: 44,
                    color: black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            for (var i = 0; i < 10; i++)
              listComponent(
                index: (i + 1).toString(),
                context: context,
                title: 'Taliban takes control over Afghanistan',
                info:
                    "Google Fonts provides a wide range of fonts that can be used to improve the fonts of the User Interface",
                comments: "1024",
                views: "100K",
                image:
                    "https://images.unsplash.com/photo-1628191080740-dad84f3c993c?ixid=MnwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=750&q=80",
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getImage();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

Column listComponent({
  BuildContext? context,
  String? title,
  String? info,
  String? comments,
  String? views,
  String? image,
  String? index,
}) {
  return Column(
    children: [
      InkWell(
        onTap: () {
          Navigator.push(
            context!,
            MaterialPageRoute(builder: (context) => SingleFeed()),
          );
        },
        child: Container(
          margin: EdgeInsets.fromLTRB(8, 0, 0, 0),
          padding: EdgeInsets.fromLTRB(6, 20, 0, 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                width: 34,
                child: Text(
                  index!,
                  style: TextStyle(
                    fontSize: 65,
                    color: black,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context!).size.width - 55,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(8, 8, 0, 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image(
                          image: NetworkImage(image!),
                          width: double.infinity,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              title!,
                              maxLines: 2,
                              style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                  fontSize: 26,
                                  color: black,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            info!,
                            maxLines: 2,
                            style: GoogleFonts.abel(
                              textStyle: TextStyle(
                                fontSize: 16,
                                color: black,
                                fontWeight: FontWeight.w400,
                                height: 1.1,
                              ),
                            ),
                          ),
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
      Container(
        decoration: BoxDecoration(
          color: white,
          border: Border(
            bottom: BorderSide(color: bordercolor, width: 1),
          ),
        ),
      )
    ],
  );
}
