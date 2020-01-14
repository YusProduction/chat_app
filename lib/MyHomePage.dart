import 'package:flutter/material.dart';
import 'package:my_chat_app/Common.dart';
import 'package:my_chat_app/NewUserChat.dart';
import 'Models.dart';
import 'ChatScreen.dart';
import 'package:firebase_database/firebase_database.dart';
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
        setState(() {});
      });
    checkPrefs();
    getMsgData();
  }

  void checkPrefs() async {
    String userName = await Common.getShared(ConstKeys.firstName);
    if (userName != null)
      setState(() {
        title = userName;
      });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  String title = null;

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
        title: Text("${title == null ? 'My Chat APP' : title}"),
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
                    title:
                        Text("${lastMsgList.elementAt(index).lastSenderName}"),
//                    subtitle: Text("${chatList.elementAt(index).msg}"),
                    subtitle: Text("${lastMsgList.elementAt(index).lastMsg}"),
                    trailing:
                        Text("${lastMsgList.elementAt(index).lastMsgTime}"),
                  ),
                );
              },
            ),
          ),
          Container(
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
                        child: Image.network(
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT1Tu8fS8Vo1xpIuQssKYs0CH7jJH5TW5y6t8xInzzKzc_fQP-L&s",
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
                            onPressed: () {},
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
          ),
          settings(settingListData: settingListData),
        ],
      ),
      floatingActionButton: tabController.index == 0
          ? FloatingActionButton(
              backgroundColor: Color(0xff075e54),
              onPressed: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new NewUserChat()));
              },
              child: Icon(
                Icons.chat,
                color: Colors.white,
              ),
            )
          : FloatingActionButton(
              backgroundColor: Color(0xff075e54),
              child: Icon(Icons.share),
              onPressed: () {},
            ),
    );
  }
}
