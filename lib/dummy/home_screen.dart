import 'dart:io';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newsapp/pages/CreateNewsStoryPage.dart';
import 'package:newsapp/dummy/AddVideo.dart';
import 'package:newsapp/pages/LoginPage.dart';
import 'package:newsapp/utils/colors.dart';
import 'package:video_player/video_player.dart';

class HomeScreen2 extends StatefulWidget {
  const HomeScreen2({Key? key}) : super(key: key);

  @override
  _HomeScreen2State createState() => _HomeScreen2State();
}

class _HomeScreen2State extends State<HomeScreen2> {
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
            builder: (context) => CreateNewsStoryPage(file: _file),
            // builder: (context) => AddVideoScreen(file: _file),
          ),
        );
      } else {
        print('No image selected.');
      }
    });
  }

  handleLogout() {
    try {
      Amplify.Auth.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } on AuthException catch (e) {
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors().white,
        title: Text('All Videos', style: TextStyle(color: CustomColors().black)),
        actions: [
          MaterialButton(
            onPressed: () {
              handleLogout();
            },
            child: Icon(Icons.logout, color: CustomColors().black, size: 20),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            for (var i = 0; i < 10; i++)
              listComponent(
                context: context,
                title:
                    'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                likes: "60K",
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

Container listComponent({
  BuildContext? context,
  String? title,
  String? likes,
  String? comments,
  String? views,
  String? image,
}) {
  return Container(
    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
    padding: EdgeInsets.fromLTRB(6, 6, 6, 6),
    decoration: BoxDecoration(
      color: CustomColors().white,
      borderRadius: BorderRadius.circular(4),
      boxShadow: [
        BoxShadow(
          color: Color(0xffdcdcdc),
          offset: Offset(1, 3), //(x,y)
          blurRadius: 6,
        ),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(8, 8, 0, 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image(
              image: NetworkImage(
                image!,
              ),
              width: MediaQuery.of(context!).size.width * 3 / 10 - 20,
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 7 / 10 - 20,
          padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  title!,
                  style: TextStyle(
                    fontSize: 12,
                    color: CustomColors().black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Views: $views',
                style: TextStyle(
                  fontSize: 11,
                  color: CustomColors().grey,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                'Likes: $likes',
                style: TextStyle(
                  fontSize: 11,
                  color: CustomColors().grey,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                'Comments: $comments',
                style: TextStyle(
                  fontSize: 11,
                  color: CustomColors().grey,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}
