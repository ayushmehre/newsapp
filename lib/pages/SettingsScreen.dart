import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newsapp/dummy/home_screen.dart';
import 'package:newsapp/pages/HomePage.dart';
import 'package:newsapp/utils/api.dart';
import 'package:newsapp/utils/colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  List listData = [];
  bool boolsearch_height = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        endDrawerEnableOpenDragGesture: false,
        body: SingleChildScrollView(
            child: Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.fromLTRB(0, 20, 16, 0),
              child: Row(
                children: [
                  InkWell(onTap: (){Navigator.pop(context);},child: Icon(Icons.arrow_back)),
                  SizedBox(width: 10,),
                  Text(
                    'Settings',
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        fontSize: 30,
                        color: CustomColors().black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              children: [
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    width: MediaQuery.of(context).size.width - 120,
                    child: Text(
                      'Dark Mode',
                      style: TextStyle(
                        fontSize: 18,
                        color: CustomColors().black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Container(height: 20, width: 50, child: SwitchScreen())
              ],
            ),
          ]),
        )));
  }
}

class SwitchScreen extends StatefulWidget {
  @override
  SwitchClass createState() => new SwitchClass();
}

class SwitchClass extends State {
  bool isSwitched = false;
  var textValue = 'Switch is OFF';

  void toggleSwitch(bool value) {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
        textValue = 'Switch Button is ON';
      });
      print('Switch Button is ON');
    } else {
      setState(() {
        isSwitched = false;
        textValue = 'Switch Button is OFF';
      });
      print('Switch Button is OFF');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      child: Transform.scale(
          scale: 1.5,
          child: Switch(
            onChanged: toggleSwitch,
            value: isSwitched,
            activeColor: Colors.deepOrangeAccent,
            activeTrackColor: Colors.black,
            inactiveThumbColor: Colors.deepOrangeAccent,
            inactiveTrackColor: Colors.grey,
          )),
    );
  }
}
