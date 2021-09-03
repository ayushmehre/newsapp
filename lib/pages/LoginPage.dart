import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qrious_createrapp/pages/InputNameScreen.dart';
import 'package:qrious_createrapp/utils/colors.dart';
import 'package:qrious_createrapp/widgets/customSignInButton.dart';
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

  Widget buildGoogleSignInButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 48.0),
      child: CustomSignInButton(
        Buttons.GoogleDark,
        text: "Continue with Google",
        onPressed: () {
          handleGoogleSignIn();
        },
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: 'Pocket',
        style: GoogleFonts.roboto(
          fontSize: 60,
          fontWeight: FontWeight.w900,
          color: red,
        ),
        children: [
          TextSpan(
              text: 'Daily',
              style: GoogleFonts.roboto(
                fontSize: 60,
                fontWeight: FontWeight.w900,
                color: Colors.black,
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: Colors.black,
            ))
          : Container(
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Spacer(),
                  Container(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [_title(), buildSubtitle()],
                    ),
                  ),
                  Spacer(),
                  buildGoogleSignInButton(),
                ],
              ),
            ),
    );
  }

  Text buildSubtitle() {
    return Text(
      'Quality Journalism in 60 seconds',
      style: TextStyle(
        fontSize: 22,
        color: Colors.black54,
      ),
    );
  }
}
