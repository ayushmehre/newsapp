import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tik_tok_ui/pages/ui.dart';
import 'package:tik_tok_ui/widgets/widgets.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

final User _user = FirebaseAuth.instance.currentUser;

class _MainPageState extends State<MainPage> {
  List<DocumentSnapshot> articles;
  final CollectionReference _newsRef =
      FirebaseFirestore.instance.collection('news');

  AudioPlayer _player;
  AudioCache cache;

  Duration position = new Duration();
  Duration musicLength = new Duration();

  void seekToSec(int sec) {
    Duration newPos = Duration(seconds: sec);
    _player.seek(newPos);
  }

  // Widget newsList() {
  //   int _selectedPage;
  //   return Container(
  //     margin: EdgeInsets.only(top: 10, bottom: 10),
  //     child: FutureBuilder<QuerySnapshot>(
  //       future: _newsRef.get(),
  //       builder: (context, snapshot) {
  //         if (snapshot.hasError) {
  //           return Scaffold(
  //             body: Center(
  //               child: Text('Error: ${snapshot.error}'),
  //             ),
  //           );
  //         }
  //
  //         if (snapshot.connectionState == ConnectionState.done) {
  //           // display data in listview User
  //           return CarouselSlider(
  //             options: CarouselOptions(
  //               height: 700,
  //               viewportFraction: 1,
  //               initialPage: 0,
  //               enableInfiniteScroll: false,
  //               reverse: false,
  //               autoPlay: false,
  //               autoPlayInterval: Duration(seconds: 3),
  //               autoPlayAnimationDuration: Duration(milliseconds: 800),
  //               enlargeCenterPage: true,
  //               scrollDirection: Axis.vertical,
  //               onPageChanged: (index, reason) => {
  //                 _selectedPage = index,
  //               },
  //             ),
  //             items: snapshot.data.docs.map((document) {
  //               return NewsStoryWidget(
  //                 newsId: document.id,
  //                 userId: document.data()['userId'],
  //                 author: document.data()['author'],
  //                 audioUrl: document.data()['audioUrl'],
  //                 content: document.data()['content'],
  //                 postedAt: document.data()['postedAt'],
  //                 sourceURL: document.data()['sourceURL'],
  //                 title: document.data()['title'],
  //               );
  //             }).toList(),
  //           );
  //         }
  //
  //         return Scaffold(
  //           body: Center(
  //             child: CircularProgressIndicator(),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchArticlesFromFirebase();

    _player = AudioPlayer();
    cache = AudioCache(fixedPlayer: _player);

    _player.durationHandler = (d) {
      setState(() {
        musicLength = d;
      });
    };

    _player.positionHandler = (d) {
      setState(() {
        musicLength = d;
      });
    };
  }

  void playAudioForIndex(int index) async {
    await _player.stop();
    var data = articles[index].data();
    var url = data['audioUrl'];
    await _player.play(url);
  }

  fetchArticlesFromFirebase() async {
    QuerySnapshot results = await _newsRef.get();
    List<DocumentSnapshot> articles = results.docs;
    setState(() {
      this.articles = articles;
    });
    playAudioForIndex(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: buildLogoWidget(context),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: articles == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : buildCarousel(),
    );
  }

  Widget buildCarousel() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 700,
        viewportFraction: 1,
        initialPage: 0,
        enableInfiniteScroll: false,
        reverse: false,
        autoPlay: false,
        autoPlayInterval: Duration(seconds: 3),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        enlargeCenterPage: true,
        scrollDirection: Axis.vertical,
        onPageChanged: (index, reason) => {
          //_selectedPage = index,
          playAudioForIndex(index)
        },
      ),
      items: articles.map((document) {
        var data = document.data();
        return NewsStoryWidget(
          newsId: document.id,
          userId: data['userId'],
          author: data['author'],
          audioUrl: data['audioUrl'],
          content: data['content'],
          postedAt: data['postedAt'],
          sourceURL: data['sourceURL'],
          title: data['title'],
          images:data['images']
        );
      }).toList(),
    );
  }
}
