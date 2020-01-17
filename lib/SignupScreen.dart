import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:email_validator/email_validator.dart';
//import 'package:firebase_auth/firebase_auth.dart';

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
        resizeToAvoidBottomPadding: true,
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
              alignment: Alignment.center,
              child: ListView(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Create a new User Account to Login My Chat App",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: TextFormField(
                        onChanged: (txt) {
                          firstName = txt;
                          //print("First name $firstName");
                        },
                        maxLength: 10,
                        inputFormatters: [
                          new BlacklistingTextInputFormatter(new RegExp(
                              r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])')),
                        ],
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
                        width: 8.0,
                      ),
                      Expanded(
                          child: TextFormField(
                        onChanged: (txt) {
                          lastName = txt;
                          //print("Last Name $lastName");
                        },
                        maxLength: 10,
                        inputFormatters: [
                          new BlacklistingTextInputFormatter(new RegExp(
                              r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])')),
                        ],
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
//                  SizedBox(
//                    height: 10,
//                  ),
                  TextFormField(
                    onChanged: (txt) {
                      phoneNumber = txt;
                    },
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    maxLength: 12,
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
                  ),
//                  SizedBox(
//                    height: 10,
//                  ),
                  TextFormField(
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
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
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
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
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
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding:
                        EdgeInsets.only(right: 70, left: 70, top: 8, bottom: 8),
                    height: 80,
                    width: 150,
//                    color: Colors.brown,
                    child: RaisedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          _doSomething();
                        }
                      },
                      color: Color(0xff075e54),
                      child: Text(
                        "SignUp",
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(32.0),
                          side: BorderSide(color: Colors.grey)),
                    ),
                  ),
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

  void _doSomething() async {
    setState(() {
      print('First Name: $firstName');
      print("Last Name: $lastName");
      print("Phone Nummber: $phoneNumber");
      print("Email: $email");
      print("password: $passwrod");
      print("Confirm Password: $confirmPassword");
    });

    //HashMap<String, Object> sdf = new HashMap();
    String lik = databaseReference.child("users").push().key;
    var data = {
      "firstName": firstName,
      "lastName": lastName,
      "phNumber": phoneNumber,
      "email": email,
      "password": passwrod,
      "key": lik,
      "profileurl": "",
    };
    databaseReference.child("users").child(lik).set(data);
    Navigator.pop(context);
  }
}
