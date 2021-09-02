import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_auth_cognito/method_channel_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qrious_createrapp/amplifyconfiguration.dart';
import 'package:qrious_createrapp/pages/HomePage.dart';
import 'package:qrious_createrapp/pages/InputNameScreen.dart';
import 'package:qrious_createrapp/tabs/bottom_nav.dart';
import 'package:qrious_createrapp/utils/colors.dart';
import 'package:qrious_createrapp/widgets/Brezier_container.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool isLoading = false;

  handleGoogleSignIn() async {
    setState(() {
      isLoading = true;
    });
    try {
      Amplify.Auth.signInWithWebUI(provider: AuthProvider.google).then((res) {
        print('\n\n \n\n $res');
        var token = res.nextStep!.additionalInfo!['token'];
        var provider = res.nextStep!.additionalInfo!['provider'];
        print("\n\n 5555 \n\n $token, $provider");

        _prefs.then((prefs) {
          prefs.setString("google_signin_token", token);
          prefs.setString("google_signin_provider", provider);
        });
        setState(() {
          isLoading = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InputNameScreen(token: token),
          ),
        );
      });
    } on AmplifyException catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e.message);
      print("\n\n 6666 \n\n");
    }
  }

  Widget _facebookButton() {
    return InkWell(
      onTap: () {
        handleGoogleSignIn();
      },
      child: Container(
        height: 60,
        margin: EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: orange,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    topLeft: Radius.circular(5),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  'G',
                  style: TextStyle(
                    color: white,
                    fontSize: 25,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                  color: orange.withOpacity(.9),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Continue with Google',
                  style: TextStyle(
                    color: white,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
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
          color: red,
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

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              // height: height,
              padding: EdgeInsets.fromLTRB(20, 160, 20, 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _title(),
                      Text(
                        'Quality Journalism in 30 seconds',
                        style: TextStyle(
                          fontSize: 16,
                          color: black,
                        ),
                      )
                    ],
                  ),
                  _facebookButton(),
                ],
              ),
            ),
    );
  }
}
