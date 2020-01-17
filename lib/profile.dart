import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_chat_app/Common.dart';
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

  String _uploadedFileURL;
  String title = null;
  void checkPrefs() async {
    String userName = await Common.getShared(ConstKeys.firstName);
    if (userName != null)
      setState(() {
        title = userName;
      });

    String url = await Common.getShared(ConstKeys.profile_img);
    if (url != null)
      setState(() {
        profile_url = url;
      });
  }

  String profile_url = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      // profile
      color: Colors.white,
      padding: EdgeInsets.all(8.0),
      child: ListView(
        children: <Widget>[
          Container(
            height: 250,
            width: 250,
            // color: Colors.blue,
            alignment: Alignment.center,
//                  padding: EdgeInsets.all(16),
            child: Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(150)),
                  child: profile_url != ""
                      ? Container(
                          height: 250,
                          width: 250,
                          // padmding: EdgeInsets.all(16.0),
                          child: Image.network(
                            "$profile_url",
                            fit: BoxFit.cover,
                            height: 230,
                            width: 230,
                            loadingBuilder: (context, child, inprogress) {
                              return inprogress == null
                                  ? child
                                  : CircularProgressIndicator();
                            },
                          ),
                        )
                      : Container(
                          height: 250,
                          width: 250,
                          //  padding: EdgeInsets.all(16.0),
                          child: CircleAvatar(
                            backgroundColor: Colors.pink,
                            child: Icon(
                              Icons.person,
                              size: 100,
                              color: Colors.white,
                            ),
                          ),
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
                          File croppedFile = await ImageCropper.cropImage(
                              sourcePath: image.path,
                              aspectRatioPresets: [
                                CropAspectRatioPreset.square
                              ],
                              androidUiSettings: AndroidUiSettings(
//                                  toolbarTitle: 'Cropper',
//                                  toolbarColor: Colors.deepOrange,
//                                  toolbarWidgetColor: Colors.white,
                                  initAspectRatio:
                                      CropAspectRatioPreset.original,
                                  lockAspectRatio: true),
                              iosUiSettings: IOSUiSettings(
                                minimumAspectRatio: 1.0,
                              ));
                          if (croppedFile != null)
                            setState(() {
                              _image = croppedFile;
                            });
                          StorageReference storageReference =
                              FirebaseStorage.instance.ref().child(
                                  'profileimages/${Path.basename(_image.path)}}');
                          StorageUploadTask uploadTask =
                              storageReference.putFile(_image);
                          await uploadTask.onComplete;
                          print('File Uploaded');

                          String url = await storageReference.getDownloadURL();
                          setState(() {
                            _uploadedFileURL = url;
                            profile_url = url;
                          });
                          String id = await Common.getShared(ConstKeys.userId);
                          //print("asdffadsfa: $profile_url");
                          databaseReference
                              .child("users")
                              .child("${id}")
                              .child("profileurl")
                              .set(profile_url);
                          Common.setPrefs(ConstKeys.profile_img, profile_url);
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
                            onPressed: () async {
                              if (UNameController.text == title) {
                                Navigator.pop(context);
                                return;
                              }
                              if (UNameController.text.length > 0) {
                                print(UNameController.text);
                                setState(() {
                                  title = UNameController.text;
                                });

                                String id =
                                    await Common.getShared(ConstKeys.userId);
                                databaseReference
                                    .child("users")
                                    .child("${id}")
                                    .child("firstName")
                                    .set(UNameController.text);
                                Common.setPrefs(
                                    ConstKeys.firstName, UNameController.text);
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
