import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/utils/colors.dart';
import 'package:newsapp/widgets/custom_toggle_switch.dart';

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
        appBar: AppBar(
          title: Text("Settings"),
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back)),
          backgroundColor: CustomColors().grey,
        ),
        body: SingleChildScrollView(
            child: Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(20, 20, 20, 00),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // buildSettingAppbar(context),
            buildDarkMode(context),
            Divider()
          ]),
        ),),);
  }

  Row buildDarkMode(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
            width: MediaQuery.of(context).size.width - 100,
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
        CustomToggleSwitch()
      ],
    );
  }
  //
  // Container buildSettingAppbar(BuildContext context) {
  //   return Container(
  //     margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
  //     child: Row(
  //       children: [
  //         InkWell(
  //             onTap: () {
  //               Navigator.pop(context);
  //             },
  //             child: Icon(Icons.arrow_back)),
  //         SizedBox(
  //           width: 10,
  //         ),
  //         Text(
  //           'Settings',
  //           style: GoogleFonts.roboto(
  //             textStyle: TextStyle(
  //               fontSize: 30,
  //               color: CustomColors().black,
  //               fontWeight: FontWeight.w700,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
