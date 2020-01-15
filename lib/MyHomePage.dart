import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_chat_app/Common.dart';
import 'package:my_chat_app/NewUserChat.dart';
import 'package:my_chat_app/profile.dart';
import 'Models.dart';
import 'ChatScreen.dart';
import 'settings.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  TextEditingController emailInputController = new TextEditingController();
  TextEditingController pwdInputController = new TextEditingController();
  TextEditingController UNameController = new TextEditingController();

  int cT = 0;

  List<ContactModel> contactList = new List();
  List<UsersLastMsg> lastMsgList = new List();
  List<settingListModel> settingListData = new List();
  bool loading = false;
  var fabIcon = Icons.message;

  final databaseReference = FirebaseDatabase.instance.reference();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: 0,
    )..addListener(() {
        setState(() {
          switch (tabController.index) {
            case 0:
              fabIcon = Icons.message;
              break;
            case 1:
              fabIcon = Icons.camera_enhance;
              break;
            case 2:
              fabIcon = Icons.share;
              break;
          }
        });
      });
//    checkPrefs();
    getMsgData();
  }

  String title = null;
//  void checkPrefs() async {
//    String userName = await Common.getShared(ConstKeys.firstName);
//    if (userName != null)
//      setState(() {
//        title = userName;
//      });
//  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void getMsgData() async {
    setState(() {
      loading = true;
    });
    var ref = FirebaseDatabase.instance.reference();
    ref.child("chats").onValue.listen((ondata) {
      // print(snapshot);
      setState(() {
        lastMsgList = new List();
        loading = false;
      });
      if (ondata.snapshot != null) {
        Map<dynamic, dynamic> values = ondata.snapshot.value;
        if (values != null) {
          values.forEach((key, values) {
            print("values $values");
            setState(() {
              lastMsgList.add(new UsersLastMsg(
                  key,
                  values["lastMsg"],
                  values["lastMsgTime"],
                  values["lastSenderName"],
                  values["lastSenderImage"],
                  values["firstName"]));
            });
          });
        } else
          print("user not found");
      } else {
        print("user not found");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        //  resizeToAvoidBottomInset: true,
        appBar: AppBar(
          centerTitle: true,
//        leading: Icon(Icons.add_a_photo),
//        title: Text("${title == null ? 'My Chat APP' : title}"),
          title: Text("My Chat App"),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.search), onPressed: () {}),
            PopupMenuButton(itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                    value: 1,
                    child: Text(
                      "New Group",
                    )),
                PopupMenuItem(
                  value: 2,
                  child: Text("Whatsapp broadcast"),
                ),
                PopupMenuItem(
                  value: 3,
                  child: Text("Whatsapp for web"),
                ),
                PopupMenuItem(
                  value: 4,
                  child: Text("Setting"),
                ),
              ];
            })
          ],
          bottom: TabBar(controller: tabController, tabs: [
            Tab(
              icon: Icon(Icons.chat),
              text: "Chat",
            ),
            Tab(
              icon: Icon(Icons.supervised_user_circle),
              text: "Profile",
            ),
            Tab(
              icon: Icon(Icons.settings),
              text: "Setting",
            )
          ]),
        ),
        body: TabBarView(
          controller: tabController,
          children: <Widget>[
            Container(
              child: ListView.separated(
                separatorBuilder: (context, position) {
                  return Container(
                    width: double.infinity,
                    color: Colors.grey[300],
                    // color: Colors.pink,
                    margin: EdgeInsets.only(left: 16.0, right: 16.0),
                    height: 1.0,
                    //  child: Text("sdffasd"),
                  );
                },
                itemCount: lastMsgList.length,
//              itemCount: lastMsgList.length,
                itemBuilder: (BuildContext msg, int index) {
                  return InkWell(
                    onTap: () {
                      //  print("ontap $index");
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new ChatScreen(
                                    id: lastMsgList.elementAt(index).id,
                                    title:
                                        "${lastMsgList.elementAt(index).lastSenderName}",
                                    image:
                                        "${lastMsgList.elementAt(index).lastSenderImage}",
                                  )));
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        child: ClipOval(
                          child: Image.network(
                            "${lastMsgList.elementAt(index).lastSenderImage}",
                            fit: BoxFit.cover,
                            height: 90,
                            width: 90,
                          ),
                        ),
                      ),
                      title: Text(
                          "${lastMsgList.elementAt(index).lastSenderName}"),
//                    subtitle: Text("${chatList.elementAt(index).msg}"),
                      subtitle: Text("${lastMsgList.elementAt(index).lastMsg}"),
                      trailing:
                          Text("${lastMsgList.elementAt(index).lastMsgTime}"),
                    ),
                  );
                },
              ),
            ),
            profilePage(title: title),
            settings(settingListData: settingListData),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Color(0xff075e54),
            onPressed: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new NewUserChat()));
            },
            child: Icon(fabIcon))
//      floatingActionButton: tabController.index == 0
//          ? FloatingActionButton(
//              backgroundColor: Color(0xff075e54),
//              onPressed: () {
//                Navigator.push(
//                    context,
//                    new MaterialPageRoute(
//                        builder: (context) => new NewUserChat()));
//              },
//              child: Icon(fabIcon)
////              child: Icon(
////                Icons.chat,
////                color: Colors.white,
////              ),
//              )
//          : FloatingActionButton(
//              backgroundColor: Color(0xff075e54),
//              child: Icon(Icons.share),
//              onPressed: () {},
//            ),
        );
  }
}
