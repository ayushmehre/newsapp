import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:google_fonts/google_fonts.dart';
import 'package:qrious_createrapp/models/UserObject.dart';
import 'package:qrious_createrapp/pages/HomePage.dart';
import 'package:qrious_createrapp/pages/LoginPage.dart';
import 'package:qrious_createrapp/tabs/bottom_nav.dart';
import 'package:qrious_createrapp/utils/api.dart';
import 'package:qrious_createrapp/utils/colors.dart';
import 'package:qrious_createrapp/widgets/widgets.dart';

import 'amplifyconfiguration.dart';

main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      theme: ThemeData(
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
    ); // define it once at root level.
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // openLogin();
    getCurrentUser();
    super.initState();
  }

  getCurrentUser() async {
    //Initializing Amplify
    await Amplify.addPlugin(AmplifyAuthCognito());
    await Amplify.configure(amplifyconfig);

    //Checking if user is logged in or not
    var authSession = await Amplify.Auth.fetchAuthSession();

    if (authSession.isSignedIn) {
      var user = await Amplify.Auth.getCurrentUser();
      var userAttributes = await Amplify.Auth.fetchUserAttributes();
      String email = findEmailAttribute(userAttributes);
      var exists = await checkIfUserExists(email);
      if (exists) {
        navigateToHomeScreen();
      } else {
        openLogin();
      }
    } else {
      openLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: red,
      body: Container(
        color: red,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              titleWidget(60, "Pocket", "Daily", white),
              // subTitleWidget('Quality Journalism in 30 seconds', 22, white),
            ],
          ),
        ),
      ),
    );
  }

  void openLogin() {
    // Future.delayed(Duration(seconds: 4), () {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    }
    // });
  }

  String findEmailAttribute(List<AuthUserAttribute> userAttributes) {
    String email = '';

    for (AuthUserAttribute attribute in userAttributes) {
      if (attribute.userAttributeKey == 'email') {
        email = attribute.value;
      }
    }

    return email;
  }

  Future<bool> checkIfUserExists(String email) async {
    UserObject? user = await getUserByEmail(email);
    if (user != null) {
      return true;
    } else {
      return false;
    }
  }

  void navigateToHomeScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
    );
  }
}
