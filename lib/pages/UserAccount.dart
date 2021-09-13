import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newsapp/dummy/NavbarScrollHide.dart';
import 'package:newsapp/models/UserObject.dart';
import 'package:newsapp/utils/UserUtils.dart';
import 'package:newsapp/widgets/open_web_view.dart';
import 'package:newsapp/pages/LoginPage.dart';
import 'package:newsapp/pages/SettingsScreen.dart';
import 'package:newsapp/pages/UserMyVideosFeed.dart';
import 'package:newsapp/utils/colors.dart';
import 'package:newsapp/widgets/open_web_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:webview_flutter/webview_flutter.dart';

class UserAccount extends StatefulWidget {
  const UserAccount({Key? key}) : super(key: key);

  @override
  _UserAccountState createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  UserObject? currentUser;


  @override
  void initState() {
    super.initState();
    getCurrentUserDetails();
  }
  getCurrentUserDetails()async{
    setState(() async {
      currentUser = await UserUtils.getCurrentUser();
    });
  }

  fetchPrefs() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    print("sharedPreferences.getString()");
    print(sharedPreferences.getString("USER_OBJECT_KEY"));
    return sharedPreferences.getString('USER_OBJECT_KEY');
  }

  handleLogout() {
    try {
      Amplify.Auth.signOut().then(
        (value) => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        ),
      );
    } on AuthException catch (e) {
      print(e.message);
    }
  }

  Future<void> _onShareData() async {
    await FlutterShare.share(
      title: 'Example share',
      text: 'Example share text',
      linkUrl: 'https://flutter.dev/',
      chooserTitle: 'Example Chooser Title',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
        child: Column(
          children: [
            SizedBox(height: 20),
            buildUserDetails(),

            buildCards(context, 'My Uploaded Videos', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OpenWebView("https://play.google.com/store/apps/details?id=com.flutter.homeguruji_2021_6","Rate App"),
                ),
              );
            }),
            buildCards(context, "Settings", () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NavbarScrollHide(),
                ),
              );
            }),
            buildCards(context, 'My Videos', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserMyVideosFeed(),
                ),
              );
            }),
            buildCards(context, "Share App", () {
              print("Share");
              _onShareData();
            }),
            buildCards(context, "About Us", () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OpenWebView(
                    "https://flutter.dev",
                    "About Us",
                  ),
                ),
              );
            }),
            buildCards(context, 'Rate App', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OpenWebView(
                    "https://play.google.com/store/apps/details?id=com.flutter.homeguruji_2021_6",
                    "Rate App",
                  ),
                ),
              );
            }),

            buildCards(context, 'Logout', () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return buildLogoutAlertDialog(context);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Column buildCards(BuildContext context, String title, Function callback) {
    return Column(
      children: [
        Divider(),
        InkWell(
          onTap: () {
            callback();
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
            width: MediaQuery.of(context).size.width - 16,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                color: CustomColors().black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Container buildUserDetails() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.fromLTRB(20, 20, 0, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            currentUser?.name ?? 'User Account',
            style: GoogleFonts.roboto(
              textStyle: TextStyle(
                fontSize: 44,
                color: CustomColors().black,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            currentUser?.email?.toString() ?? 'Email',
            style: GoogleFonts.roboto(
              textStyle: TextStyle(
                fontSize: 16,
                color: CustomColors().grey,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  AlertDialog buildLogoutAlertDialog(BuildContext context) {
    return AlertDialog(
      title: Text('Are you sure you want to logout?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              handleLogout();
            });
          },
          child: Text("Logout"),
        ),
      ],
    );
  }
}
