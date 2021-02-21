import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

class UI extends StatefulWidget with WidgetsBindingObserver {
  final String title,
      sourceURL,
      audioUrl,
      postedAt,
      content,
      author,
      newsId,
      userId;
  @override
  _UIState createState() => _UIState();
  UI({
    this.author,
    this.content,
    this.postedAt,
    this.sourceURL,
    this.title,
    this.newsId,
    this.userId,
    this.audioUrl,
  });
}

class _UIState extends State<UI> with TickerProviderStateMixin {
  bool playing = true;
  // IconData playBtn = Icons.play_arrow;

  AudioPlayer _player;
  AudioCache cache;

  Duration position = new Duration();
  Duration musicLength = new Duration();

  void seekToSec(int sec) {
    Duration newPos = Duration(seconds: sec);
    _player.seek(newPos);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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

    _player.play(widget.audioUrl);
    // _player.stop();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          // border: Border.all(width: 1, color: Colors.black38),
          color: Color(0xffffffff),
        ),
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(right: 16),
        padding: EdgeInsets.only(bottom: 10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(14),
                    child: Text(
                      '${widget.title}',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Stack(
                    children: [
                      Container(
                        height: 400,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Color(0xffFF375E), width: 5),
                            bottom:
                                BorderSide(color: Color(0xffFF375E), width: 5),
                          ),
                        ),
                        child: Image.network(
                          "https://blog.tubikstudio.com/wp-content/uploads/2018/04/perfect-recipes-app-ui-design-tubik.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.only(left: 14, right: 15, top: 10),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.error),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () =>
                                  _launchURL(context, widget.sourceURL),
                              child: Text(
                                'Read more at: www.cricbuzz.com',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            Text(
                              '${widget.postedAt}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black38,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(
                          Icons.whatshot_sharp,
                          color: Colors.green,
                          size: 24,
                        ),
                        SizedBox(height: 8),
                        Text(
                          '42 Shares',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.black38,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _launchURL(BuildContext context, sourceUrl) async {
    try {
      await launch(
        '${sourceUrl}',
        option: new CustomTabsOption(
          toolbarColor: Theme.of(context).primaryColor,
          enableDefaultShare: true,
          enableUrlBarHiding: true,
          showPageTitle: true,
          animation: new CustomTabsAnimation.slideIn(),
          extraCustomTabs: <String>[
            // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
            'org.mozilla.firefox',
            // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
            'com.microsoft.emmx',
          ],
        ),
      );
    } catch (e) {
      // An exception is thrown if browser app is not installed on Android device.
      debugPrint(e.toString());
    }
  }
}
