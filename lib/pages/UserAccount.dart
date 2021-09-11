import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newsapp/models/UserObject.dart';
import 'package:newsapp/pages/LoginPage.dart';
import 'package:newsapp/pages/SettingsScreen.dart';
import 'package:newsapp/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAccount extends StatefulWidget {
  const UserAccount({Key? key}) : super(key: key);

  @override
  _UserAccountState createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  UserObject? currentUser;

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
            Container(
              margin: EdgeInsets.fromLTRB(16, 20, 16, 40),
              child: Column(
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
                    currentUser?.email ?? 'User Email',
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
            ),

            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsScreen(),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                width: MediaQuery.of(context).size.width - 16,
                child: Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 18,
                    color: CustomColors().black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            //
            InkWell(
              onTap: () {
                _onShareData();
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                width: MediaQuery.of(context).size.width - 16,
                child: Text(
                  'Share App',
                  style: TextStyle(
                    fontSize: 18,
                    color: CustomColors().black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                width: MediaQuery.of(context).size.width - 16,
                child: Text(
                  'About Us',
                  style: TextStyle(
                    fontSize: 18,
                    color: CustomColors().black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                width: MediaQuery.of(context).size.width - 16,
                child: Text(
                  'Rate Us',
                  style: TextStyle(
                    fontSize: 18,
                    color: CustomColors().black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            //
            InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return buildLogoutAlertDialog(context);
                    });
                // handleLogout();
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                width: MediaQuery.of(context).size.width - 16,
                child: Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 18,
                    color: CustomColors().black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AlertDialog buildLogoutAlertDialog(BuildContext context) {
    return AlertDialog(
      title: Text('Are you sure you want to logout?'),
      actions: <Widget>[
        MaterialButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        ),
        MaterialButton(
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
