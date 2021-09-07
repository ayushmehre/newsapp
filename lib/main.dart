import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:google_fonts/google_fonts.dart';
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
    // initializing amplify
    await Amplify.addPlugin(AmplifyAuthCognito());
    await Amplify.configure(amplifyconfig);

    try {
      var userAttributes = await Amplify.Auth.fetchUserAttributes();
      for (var i = 0; i < userAttributes.length; i++) {
        if (userAttributes[i].userAttributeKey == 'email') {
          final email = userAttributes[i].value;
          await getUserByEmailGetRequest(email, (code, response) {
            if (code != null) {
              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BottomNav(),
                  ),
                );
              }
            } else {
              openLogin();
            }
          });
        } else {
          openLogin();
        }
      }
      if (userAttributes.length == 0) {
        openLogin();
      }
      //send user to dashboard
    } on Exception catch (e) {
      print('\n\n \n\n ****************: $e');
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
}
