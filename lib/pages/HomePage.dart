import 'dart:io';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newsapp/models/NewsStoryObject.dart';
import 'package:newsapp/pages/CreateNewsStoryPage.dart';
import 'package:newsapp/dummy/AddVideo.dart';
import 'package:newsapp/pages/LoginPage.dart';
import 'package:newsapp/pages/VideoStoriesFeed.dart';
import 'package:newsapp/utils/api.dart';
import 'package:newsapp/utils/colors.dart';
import 'package:newsapp/widgets/widgets.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_video_info/flutter_video_info.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late VideoPlayerController _controller;
  final videoInfo = FlutterVideoInfo();
  late File _file;
  final selected = ImagePicker();
  late bool boolfeedsload=false;
  late List<NewsStoryObject> Feedlist=[];

  @override
  void initState() {
    super.initState();
    getHomePageStoriesFeeds();

  }

  getHomePageStoriesFeeds()async {
    Map<String,dynamic> response= await API().getNewsStory();
    if(!response.isEmpty){
      if(response["success"]){
        List<NewsStoryObject> tmpList=[];
        for(var dctData in response["data"]){
          NewsStoryObject feedObj = NewsStoryObject.fromJson(dctData);
          tmpList.add(feedObj);
        }
        setState(() {
          Feedlist=tmpList;
          boolfeedsload=true;
        });
        print(Feedlist.toString());
      }else{
        setState(() {
          boolfeedsload=true;
        });
      }
    }else{
      setState(() {
        boolfeedsload=true;
      });
    }
  }

  Future getImage() async {
    final selectedImage = await selected.pickVideo(source: ImageSource.gallery);
    var a = await videoInfo.getVideoInfo(selectedImage!.path);

    setState(() {
      if (selectedImage != null) {
        _file = File(selectedImage.path);
        VideoPlayerController.file(File(selectedImage.path));

        var endDuration = (a!.duration)!/1000 <= 60;
        var startDuration = (a.duration)!/1000 >= 10;
        var filelength = (_file.lengthSync() / 1024 / 1024) <= 50;
        if(!startDuration) {
          showErrorDialog(context, "Error", "Please select file greater then 10 seconds");
          return;
        }
        if(!endDuration) {
          showErrorDialog(context, "Error", "Please select file less then 60 seconds");
          return;
        }
        if(!filelength) {
          showErrorDialog(context, "Error", "File size should not be greater then 50MB");
          return;
        }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors().white,
      appBar: AppBar(
        toolbarHeight: 4,
        backgroundColor: CustomColors().white,
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
                    color: CustomColors().black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            boolfeedsload?Container(
              child: Feedlist.length==0?Container(
                child: Center(child: Text("Error")),
              ):Container(
                height: MediaQuery.of(context).size.height-180,
                child: ListView.builder(
                    itemCount: Feedlist.length,
                    itemBuilder: (context,index){
                      return  listComponent(
                            index: (index + 1).toString(),
                            context: context,
                            title: Feedlist[index].title,
                            info: Feedlist[index].descption,
                            comments: Feedlist[index].commentsCount.toString(),
                            views: Feedlist[index].viewCount.toString(),
                            image:
                                "https://images.unsplash.com/photo-1628191080740-dad84f3c993c?ixid=MnwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=750&q=80",
                          );
                    }
                ),
              ),
            ):Container(
              height: MediaQuery.of(context).size.height,
              child: customProgressIndicator(),
            )
            // for (var i = 0; i < 10; i++)
            //   listComponent(
            //     index: (i + 1).toString(),
            //     context: context,
            //     title: 'Taliban takes control over Afghanistan',
            //     info:
            //         "Google Fonts provides a wide range of fonts that can be used to improve the fonts of the User Interface",
            //     comments: "1024",
            //     views: "100K",
            //     image:
            //         "https://images.unsplash.com/photo-1628191080740-dad84f3c993c?ixid=MnwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=750&q=80",
            //   ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getImage();
        },
        backgroundColor: CustomColors().red,
        child: Icon(Icons.add,size: 40,),
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
            MaterialPageRoute(builder: (context) => VideoStoriesFeed()),
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
                    color: CustomColors().black,
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
                            alignment: Alignment.centerLeft,
                            child: Text(
                              title!,
                              maxLines: 2,
                              style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                  fontSize: 26,
                                  color: CustomColors().black,
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
                                color: CustomColors().black,
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
          color: CustomColors().white,
          border: Border(
            bottom: BorderSide(color: CustomColors().bordercolor, width: 1),
          ),
        ),
      )
    ],
  );
}
