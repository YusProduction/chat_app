import 'package:flutter/material.dart';
import 'package:my_chat_app/MyHomePage.dart';
import 'package:my_chat_app/SigninScreen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'MyHomePage.dart';
//import 'SigninScreen.dart';
import 'NewUserChat.dart';

void main() => runApp(MyApp());
Map<int, Color> color = {
  50: Color.fromRGBO(136, 14, 79, .1),
  100: Color.fromRGBO(136, 14, 79, .2),
  200: Color.fromRGBO(136, 14, 79, .3),
  300: Color.fromRGBO(136, 14, 79, .4),
  400: Color.fromRGBO(136, 14, 79, .5),
  500: Color.fromRGBO(136, 14, 79, .6),
  600: Color.fromRGBO(136, 14, 79, .7),
  700: Color.fromRGBO(136, 14, 79, .8),
  800: Color.fromRGBO(136, 14, 79, .9),
  900: Color.fromRGBO(136, 14, 79, 1),
};

class MyApp extends StatelessWidget {
  MaterialColor colorCustom = MaterialColor(0xff075e54, color);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //primarySwatch: Colors.green,
        primarySwatch: colorCustom,
      ),
      home: //MyHomePage(),

          SigninScreen(),
    );
  }
}
