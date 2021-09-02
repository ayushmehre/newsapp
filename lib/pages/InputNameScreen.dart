import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qrious_createrapp/tabs/bottom_nav.dart';
import 'package:qrious_createrapp/utils/api.dart';
import 'package:qrious_createrapp/utils/colors.dart';
import 'package:qrious_createrapp/widgets/Brezier_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InputNameScreen extends StatefulWidget {
  final String token;

  const InputNameScreen({Key? key, required this.token}) : super(key: key);

  @override
  _InputNameScreenState createState() => _InputNameScreenState();
}

class _InputNameScreenState extends State<InputNameScreen> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late String name;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        iconTheme: IconThemeData(color: black),
        elevation: 0,
      ),
      body: Container(
        height: height,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 50),
                _entryField("Enter name"),
                SizedBox(height: 20),
                Container(
                  alignment: Alignment.centerRight,
                  child: _submitButton(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _entryField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          SizedBox(height: 10),
          TextFormField(
            obscureText: isPassword,
            decoration: InputDecoration(
              hintText: "Enter $title",
              hintStyle: TextStyle(fontSize: 16, color: grey),
              border: InputBorder.none,
              fillColor: fillColor,
              filled: true,

            ),
            validator: (val) {
              return val!.isEmpty
                  ? "Name field is required"
                  : null;
            },
            onChanged: (val) {
              name = val;
            },
          )
        ],
      ),
    );
  }

  handleLogin() {
    if (_formKey.currentState!.validate()) {
      Amplify.Auth.fetchUserAttributes().then((value) {
        for (var i = 0; i < value.length; i++) {
          if (value[i].userAttributeKey == 'email') {
            final email = value[i].value;
            print(value[i].userAttributeKey);

            signupUserPostRequest(
              email: email,
              name: name,
              token: widget.token,
              callback: (code, response) {
                if (code == 'Success') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BottomNav(),
                    ),
                  );
                }
              },
            );
          }
        }

        // final email =
        // signupUserPostRequest();
      });
    }
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () {
        handleLogin();
      },
      child: Container(
        width: 100,
        padding: EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: red,
          borderRadius: BorderRadius.all(Radius.circular(5)),
          // boxShadow: <BoxShadow>[
          //   BoxShadow(
          //     color: Colors.grey.shade200,
          //     offset: Offset(2, 4),
          //     blurRadius: 5,
          //     spreadRadius: 2,
          //   ),
          // ],
        ),
        child: Text(
          'Continue',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}
