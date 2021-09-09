import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:google_fonts/google_fonts.dart';
import 'package:qrious_createrapp/models/UserObject.dart';
import 'package:qrious_createrapp/pages/LoginPage.dart';
import 'package:qrious_createrapp/tabs/bottom_nav.dart';
import 'package:qrious_createrapp/utils/UserUtils.dart';
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
      UserObject? userObj = await checkIfUserExists(email);
      print('\n\n UserObject? userObj :> $userObj');
      if (userObj != null) {
        navigateToHomeScreen();
        UserUtils.saveUserObject(userObj);
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
      backgroundColor: CustomColors().red,
      body: Container(
        color: CustomColors().red,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              getTitleWidget(60, "Pocket", "Daily", CustomColors().white),
              // subTitleWidget('Quality Journalism in 30 seconds', 22, white),
            ],
          ),
        ),
      ),
    );
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

  Future<UserObject?> checkIfUserExists(String email) async {
    UserObject? user = await API().getUserByEmail(email);
    if (user != null) {
      return user;
    } else {
      return null;
    }
  }

  void navigateToHomeScreen() {
    Future.delayed(Duration(seconds: 4), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNav(),
          ),
        );
      }
    });
  }

  void openLogin() {
    Future.delayed(Duration(seconds: 4), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      }
    });
  }
}
