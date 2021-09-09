import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:qrious_createrapp/tabs/bottom_nav.dart';
import 'package:qrious_createrapp/utils/api.dart';
import 'package:qrious_createrapp/utils/colors.dart';
import 'package:qrious_createrapp/widgets/customSignInButton.dart';
import 'package:qrious_createrapp/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool isLoading = false;
  late String name;

  handleGoogleSignIn() async {
    setState(() {
      isLoading = true;
    });
    try {
      var res = await Amplify.Auth.signInWithWebUI(
        provider: AuthProvider.google,
      );
      print('\n\n \n\n $res');
      var token = res.nextStep!.additionalInfo!['token'];
      var provider = res.nextStep!.additionalInfo!['provider'];
      _prefs.then((prefs) {
        prefs.setString("google_signin_token", token);
        prefs.setString("google_signin_provider", provider);
      });

      handleLogin(token);
    } on AmplifyException catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e.message);
      print("\n\n 6666 \n\n");
    }
  }

  handleLogin(String token) async {
    try {
      var value = await Amplify.Auth.fetchUserAttributes();
      print("\n\n \n\n $value \n\n \n\n");

      for (var i = 0; i < value.length; i++) {
        if (value[i].userAttributeKey == 'email') {
          final email = value[i].value;
          print(value[i].userAttributeKey);

          createNewUser(email, token);
        }
      }
    } catch (e) {
      print("\n\n Error $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void createNewUser(email, String token) {
    API().signupCreateNewUser(
      email: email,
      name: "Ankit Jain",
      token: token,
      callback: (code, response) {
        print("\n\n \n\n User Object Response >> $response \n\n \n\n");
        setState(() {
          isLoading = false;
        });
        if (code == 'Success') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNav(),
            ),
          );
        }
        if(code == null) {
          setState(() {
            isLoading = false;
          });
          return;
        }
      },
    );
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
                      children: [
                        getTitleWidget(
                          60,
                          "Pocket",
                          "Daily",
                          CustomColors().red,
                        ),
                        subTitleWidget(
                          'Quality Journalism in 30 seconds',
                          18,
                          Colors.black54,
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  buildGoogleSignInButton(),
                ],
              ),
            ),
    );
  }
}
