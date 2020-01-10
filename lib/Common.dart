import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Common {
  static void showToast(String msg) {
    Fluttertoast.showToast(
        msg: '$msg',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white);
  }

  static void setPrefs(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static Future<String> getShared(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? null;
  }
}

class ConstKeys {
  static String email = "email";
  static String firstName = "fname";
  static String lastName = "lname";
  static String password = "password";
  static String userId = "userid";
  static String loginStatus = "loginStatus";
}
