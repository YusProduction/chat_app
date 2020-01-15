import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_chat_app/Common.dart';
import 'Models.dart';

class profilePage extends StatefulWidget {
  String title;
  profilePage({this.title});
  @override
  _profilePageState createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  TextEditingController UNameController = new TextEditingController();
  File _image;

  @override
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkPrefs();
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
      padding: EdgeInsets.all(16.0),
      child: Column(
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
                          fit: BoxFit.contain,
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
                            source: ImageSource.camera);
                        if (image != null) {
                          setState(() {
                            _image = image;
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
//                  color: Colors.grey,
//                  alignment: Alignment.center,
            padding: EdgeInsets.all(8),
//                  flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "${title}",
                  style: TextStyle(fontSize: 25),
                ),
                SizedBox(
                  width: 20,
                ),
                IconButton(
                  onPressed: () {
                    UNameController.text = title;
                    UNameController.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: UNameController.text.length);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Edit"),
                          content: TextField(
                            controller: UNameController,
                            autofocus: true,
//                                  onChanged: (txt) {
//                                    UserName = txt;
//                                    //print("Last Name $lastName");
//                                  },
                          ),
                          actions: [
                            FlatButton(
                              child: Text("Yes"),
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
                                  // UserName = "";
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
