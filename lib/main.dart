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
    await Amplify.addPlugin(AmplifyAuthCognito());
    await Amplify.configure(amplifyconfig);
    try {
      Amplify.Auth.fetchUserAttributes().then((currentUser)async {
        print(currentUser);
        for (var i = 0; i < currentUser.length; i++) {
          if (currentUser[i].userAttributeKey == 'email') {
            final email = currentUser[i].value;
            await getUserByEmailGetRequest(email, (code, response) {
              // print(currentUser);
              if (code != null) {
                print('aaaa $email $code $response');
                // if (currentUser.userId != null) {}
                if(mounted) {
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
          }else{
            openLogin();
          }
        }
        if(currentUser.length==0){
          openLogin();
        }
      }).catchError((onError){
        print("*********");
        openLogin();
      });
      // openLogin();


      // print("\n\n \n\n awsUser: ${awsUser.userId}");
      // if (awsUser.userId != null) {
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => BottomNav(),
      //     ),
      //   );
      // }
      //send user to dashboard
    } on Exception catch (e) {
      print('\n\n \n\n ****************: $e');
      // openLogin();
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
              _title(),
              Text(
                'Quality Journalism in 30 seconds',
                style: TextStyle(
                  fontSize: 16,
                  color: white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: 'Pocket',
        style: GoogleFonts.portLligatSans(
          fontSize: 60,
          fontWeight: FontWeight.w700,
          color: white,
        ),
        children: [
          TextSpan(
            text: 'Daily',
            style: TextStyle(color: black, fontSize: 60),
          ),
        ],
      ),
    );
  }

  void openLogin() {
    // Future.delayed(Duration(seconds: 4), () {
    if(mounted) {
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
