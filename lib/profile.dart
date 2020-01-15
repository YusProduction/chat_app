import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_chat_app/Common.dart';
import 'package:image_crop/image_crop.dart';
import 'package:firebase_database/firebase_database.dart';
import 'Models.dart';

class profilePage extends StatefulWidget {
  String title;
  profilePage({this.title});
  @override
  _profilePageState createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  TextEditingController UNameController = new TextEditingController();
  final databaseReference = FirebaseDatabase.instance.reference();
  File _image;
  final cropKey = GlobalKey<CropState>();

  List<ProfileListModel> profileListData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkPrefs();
    getProfileData();
  }

  void getProfileData() {
    setState(() {
      profileListData = new List();
      profileListData.add(new ProfileListModel(
          Icons.check_circle_outline, "About", "In a Meeting"));
      profileListData.add(
          new ProfileListModel(Icons.phone, "Phone Number", "+92 340 1514691"));
    });
  }

  String title = null;
  void checkPrefs() async {
    String userName = await Common.getShared(ConstKeys.firstName);
    if (userName != null)
      setState(() {
        title = userName;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // profile
      color: Colors.white,
      padding: EdgeInsets.all(8.0),
      child: ListView(
        children: <Widget>[
          Container(
//                  color: Colors.blue,
            alignment: Alignment.center,
//                  padding: EdgeInsets.all(16),
            child: Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(120)),
                  child: _image == null
                      ? Image.network(
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT1Tu8fS8Vo1xpIuQssKYs0CH7jJH5TW5y6t8xInzzKzc_fQP-L&s",
                          fit: BoxFit.cover,
                          height: 230,
                          width: 230,
                          loadingBuilder: (context, child, inprogress) {
                            return inprogress == null
                                ? child
                                : CircularProgressIndicator();
                          },
                        )
                      : Image.file(
                          _image,
                          key: cropKey,
                          fit: BoxFit.cover,
                          height: 230,
                          width: 230,
                        ),
                ),
                Positioned(
                  right: 8,
                  bottom: 8,
                  child: CircleAvatar(
                    radius: 30,
                    child: IconButton(
                      onPressed: () async {
                        var image = await ImagePicker.pickImage(
                            source: ImageSource.camera,
                            maxWidth: 230.0,
                            maxHeight: 230.0);
                        if (image != null) {
                          setState(() {
                            _image = image;
//                            var UImg = {
//                              "UserImage": _image,
//                            };
//                            databaseReference.child("UserImg").push().set(UImg);
                          });
                        }
                      },
//                            iconSize: 25,
                      icon: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    backgroundColor: Color(0xff075e54),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
//            color: Colors.grey,
//                  alignment: Alignment.center,
//            padding: EdgeInsets.all(8),
//                  flex: 1,
            child: ListTile(
              leading: CircleAvatar(
                child: Icon(
                  Icons.person_outline,
                  color: Color(0xff075e54),
                ),
//                      backgroundColor: Color(0xff075e54),
                backgroundColor: Colors.transparent,
              ),
              title: Text(
                "${title}",
                style: TextStyle(fontSize: 25),
              ),
              subtitle: Text("This is your good Name You can edit it here"),
              trailing: IconButton(
                onPressed: () {
                  UNameController.text = title;
                  UNameController.selection = TextSelection(
                      baseOffset: 0, extentOffset: UNameController.text.length);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Edit Name"),
                        content: TextField(
                          controller: UNameController,
                          autofocus: true,
//                            onChanged: (txt) {
//                              UserName = txt;
//                              //print("Last Name $lastName");
//                            },
                        ),
                        actions: [
                          FlatButton(
                            child: Text("Save"),
                            onPressed: () {
                              if (UNameController.text == title) {
                                Navigator.pop(context);
                                return;
                              }
                              if (UNameController.text.length > 0) {
                                print(UNameController.text);
                                setState(() {
                                  title = UNameController.text;
                                });
                                var UName = {
                                  "UserName": UNameController.text,
//                                    "UserImage": _image
                                };
                                databaseReference
                                    .child("UserName")
                                    .push()
                                    .set(UName);
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: Icon(
                  Icons.edit,
                ),
              ),
            ),
          ),
          Container(
            height: 1,
            color: Colors.grey,
            margin: EdgeInsets.only(left: 70, right: 30),
          ),
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: profileListData.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: CircleAvatar(
                    child: Icon(
                      profileListData.elementAt(index).icon,
                      color: Color(0xff075e54),
                    ),
//                      backgroundColor: Color(0xff075e54),
                    backgroundColor: Colors.transparent,
                  ),
                  title: Text("${profileListData.elementAt(index).name}"),
                  subtitle:
                      Text("${profileListData.elementAt(index).description}"),
                  onTap: () {},
                );
              }),
        ],
      ),
    );
  }
}
