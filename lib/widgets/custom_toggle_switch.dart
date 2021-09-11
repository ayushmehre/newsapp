import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomToggleSwitch extends StatefulWidget {
  @override
  SwitchClass createState() => new SwitchClass();
}

class SwitchClass extends State {
  bool isSwitched = false;
  var textValue = 'Switch is OFF';

  setDarkModePrefs(bool value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    print("sharedPreferences.setBool(DARK_MODE_KEY)$value");
    sharedPreferences.setBool('DARK_MODE_KEY', value);
  }

  void toggleSwitch(bool value) {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
        textValue = 'Switch Button is ON';
        setDarkModePrefs(true);
      });
      print('Switch Button is ON');
    } else {
      setState(() {
        isSwitched = false;
        textValue = 'Switch Button is OFF';
        setDarkModePrefs(false);
      });
      print('Switch Button is OFF');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      child: Transform.scale(
          scale: 1.5,
          child: Switch(
            onChanged: toggleSwitch,
            value: isSwitched,
            activeColor: Colors.deepOrangeAccent,
            activeTrackColor: Colors.black,
            inactiveThumbColor: Colors.deepOrangeAccent,
            inactiveTrackColor: Colors.grey,
          )),
    );
  }
}
