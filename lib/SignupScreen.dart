import 'dart:collection';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final databaseReference = FirebaseDatabase.instance.reference();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> passKey = GlobalKey<FormState>();

  TextEditingController firstNameInputController = new TextEditingController();
  TextEditingController lastNameInputController = new TextEditingController();
  TextEditingController phNumberInputController = new TextEditingController();
  TextEditingController emailInputController = new TextEditingController();
  TextEditingController pwdInputController = new TextEditingController();
  TextEditingController confirmPwdInputController = new TextEditingController();

  @override
  initState() {
    super.initState();
  }

  String firstName = "";
  String lastName = "";
  String email = "";
  String phoneNumber = "";
  String passwrod = "";
  String confirmPassword = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // resizeToAvoidBottomInset: true,
        //   resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          title: Center(
            child: Text("Create Account"),
          ),
        ),
        //resizeToAvoidBottomInset: false,
        body: Form(
            //autovalidate: true,
            key: _formKey,
            child: Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: TextFormField(
                          onChanged: (txt) {
                            firstName = txt;
                            //print("First name $firstName");
                          },
                          decoration: InputDecoration(
                              hintText: "First Name",
                              prefixIcon: Icon(Icons.supervised_user_circle),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0))),
                          keyboardType: TextInputType.text,
                          controller: firstNameInputController,
                          validator: (value) {
                            if (value.length < 3) {
                              return 'Name not long enough';
                            }
                          },
                        )),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                            child: TextFormField(
                          onChanged: (txt) {
                            lastName = txt;
                            //print("Last Name $lastName");
                          },
                          decoration: InputDecoration(
                              hintText: "Last Name",
                              prefixIcon: Icon(Icons.supervised_user_circle),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0))),
                          keyboardType: TextInputType.text,
                          controller: lastNameInputController,
                          //onSaved: (value) => _name = value,
                          validator: (value) {
                            if (value.length < 2) {
                              return "Name not long enough";
                            }
                          },
                        )),
                      ],
                    ),
                  ),
                  Expanded(
                      child: TextFormField(
                    onChanged: (txt) {
                      phoneNumber = txt;
                    },
                    decoration: InputDecoration(
                        hintText: "Phone No.",
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0))),
                    keyboardType: TextInputType.phone,
                    controller: phNumberInputController,
                    validator: (value) {
                      var potentialNumber = int.tryParse(value);
                      if (potentialNumber == null) {
                        return "Enter phone number";
                      }
                    },
                  )),
                  Expanded(
                      child: TextFormField(
                    onChanged: (txt) {
                      email = txt;
                    },
                    decoration: InputDecoration(
                        hintText: "Email",
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0))),
                    keyboardType: TextInputType.emailAddress,
                    controller: emailInputController,
                    validator: (value) {
                      if (!validateEmail(value)) {
                        return 'Please enter a valid email';
                      }

//                      if (!EmailValidator.validate(value)) {
//                        return 'Please enter a valid email';
//                      }
                    },
                  )),
                  Expanded(
                      child: TextFormField(
                    //key: passKey,
                    onChanged: (txt) {
                      passwrod = txt;
                    },
                    decoration: InputDecoration(
                        hintText: "Password",
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0))),
                    obscureText: true,
                    controller: pwdInputController,
                    validator: (value) {
                      var result = value.length < 4
                          ? "Password should have at least 4 characters"
                          : null;
                      return result;
                    },
                  )),
                  Expanded(
                      child: TextFormField(
                    onChanged: (txt) {
                      confirmPassword = txt;
                    },
                    decoration: InputDecoration(
                        hintText: "Confirm Password",
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0))),
                    obscureText: true,
                    controller: confirmPwdInputController,
                    validator: (confirmation) {
                      if (confirmation != passwrod) {
                        return 'Passwords do not match';
                      } else {
                        return null;
                      }
                    },
                  )),
                  Expanded(
                    child: SizedBox(
                        width: double.infinity,
                        //height: double.infinity,
                        child: RaisedButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              _doSomething();
                            }
                          },
                          color: Color(0xff00C0B5),
                          child: Text(
                            "SignUp",
                            style: TextStyle(fontSize: 20.0),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20.0),
                              side: BorderSide(color: Colors.grey)),
                        )),
                  )
                ],
              ),
            )));
  }

  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

  void _doSomething() {
    setState(() {
      print('First Name: $firstName');
      print("Last Name: $lastName");
      print("Phone Nummber: $phoneNumber");
      print("Email: $email");
      print("password: $passwrod");
      print("Confirm Password: $confirmPassword");
    });

    //HashMap<String, Object> sdf = new HashMap();

    var data = {
      "firstName": firstName,
      "lastName": lastName,
      "phNumber": phoneNumber,
      "email": email,
      "password": passwrod,
    };
    databaseReference.child("users").push().set(data);
    Navigator.pop(context);
  }
}
