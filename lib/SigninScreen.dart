import 'package:email_validator/email_validator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/ChatScreen.dart';
import 'package:my_chat_app/Common.dart';
import 'package:my_chat_app/MyHomePage.dart';
import 'SignupScreen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SigninScreen extends StatefulWidget {
  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  TextEditingController emailInputController = new TextEditingController();
  TextEditingController pwdInputController = new TextEditingController();

  @override
  initState() {
    super.initState();
    checkPrefs();
  }

  void checkPrefs() async {
    String xyz = await Common.getShared(ConstKeys.loginStatus);
    print("xyz $xyz");
    if (xyz != null && xyz == "true") {
      Navigator.pushReplacement(context,
          new MaterialPageRoute(builder: (context) => new MyHomePage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: Center(
          child: Text(
            "Login",
            style: TextStyle(fontSize: 30),
          ),
        ),
      ),
      //resizeToAvoidBottomInset: false,
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Image.network(
                  "https://i.ytimg.com/vi/9XMt2hChbRo/maxresdefault.jpg"),
            ),
            SizedBox(
//            height: 20.0,
//            width: 20.0,
                ),
            Expanded(
                flex: 2,
                child: Form(
                    key: _loginFormKey,
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: "Email",
                                prefixIcon: Icon(Icons.email),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(32.0))),
                            keyboardType: TextInputType.emailAddress,
                            controller: emailInputController,
                            //autovalidate: true,
                            validator: (value) {
                              if (!validateEmail(value)) return "Invalid email";
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: "Password",
                                prefixIcon: Icon(Icons.lock),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(32.0))),
                            obscureText: true,
                            controller: pwdInputController,
                            validator: pwdValidator,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: RaisedButton(
                                  onPressed: () {},
                                  color: Color(0xff00C0B5),
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(fontSize: 20.0),
                                  ),
                                  padding: EdgeInsets.all(15.0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(32.0),
                                      side: BorderSide(color: Colors.blue)),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: RaisedButton(
                                  onPressed: () {
//                                  if (_loginFormKey.currentState.validate()) {
//                                    _loginFormKey.currentState.save();

                                    var ref =
                                        FirebaseDatabase.instance.reference();
                                    try {
                                      ref
                                          .child("users")
                                          .orderByChild("email")
                                          .equalTo(
                                              "${emailInputController.text}")
                                          //  .orderByChild("password")
                                          // .equalTo("asdf1234")
                                          .once()
                                          .then((DataSnapshot snapshot) {
                                        if (snapshot != null) {
                                          Map<dynamic, dynamic> values =
                                              snapshot.value;
                                          if (values != null)
                                            values.forEach((key, values) {
                                              if (values["password"] ==
                                                  "${pwdInputController.text}") {
                                                print("success: yehoooo");

                                                Common.setPrefs(ConstKeys.email,
                                                    values["email"]);
                                                Common.setPrefs(
                                                    ConstKeys.userId,
                                                    key.toString());
                                                Common.setPrefs(
                                                    ConstKeys.password,
                                                    values["password"]);
                                                Common.setPrefs(
                                                    ConstKeys.firstName,
                                                    values["firstName"]);
                                                Common.setPrefs(
                                                    ConstKeys.lastName,
                                                    values["lastName"]);
                                                Common.setPrefs(
                                                    ConstKeys.loginStatus,
                                                    "true");

                                                Navigator.pushReplacement(
                                                    context,
                                                    new MaterialPageRoute(
                                                        builder: (context) =>
                                                            new MyHomePage()));
                                              } else {
                                                print("Invalid password");
                                                setState(() {
                                                  pwdInputController
                                                      .clear(); // = "";
                                                });
                                                Common.showToast(
                                                    "invalid pasword");
                                              }
                                            });
                                          else
                                            print("Invalid user");
                                          //Common.showToast("invalid User");
                                        } else {
                                          print("user not found");
                                          Common.showToast("invalid");
                                        }
                                      });
                                    } catch (ex) {
                                      print("errrr" + ex);
                                    }
                                  },
                                  padding: EdgeInsets.all(15.0),
                                  color: Color(0xff00C0B5),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(32.0),
                                      side: BorderSide(color: Colors.blue)),
                                  child: Text(
                                    "Sign in",
                                    style: TextStyle(fontSize: 20.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(children: <Widget>[
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(
                                  left: 70,
                                  right: 70,
                                ),
                                child: RaisedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) =>
                                                new SignupScreen()));
                                  },
                                  padding: EdgeInsets.all(15.0),
                                  color: const Color(0xff00C0B5),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(32.0),
                                      side: BorderSide(color: Colors.blue)),
                                  child: Text(
                                    "Sign up",
                                    style: TextStyle(fontSize: 20.0),
                                  ),
                                ),
                              ),
                            ),
                          ]),
                        ],
                      ),
                    ))),
          ],
        ),
      ),
    );
  }

  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }
}

String pwdValidator(String value) {
  if (value.length < 4) {
    return 'Password must be longer than 4 characters';
  } else {
    return null;
  }
}
