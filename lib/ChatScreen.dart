import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'Models.dart';
import 'Common.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  String id;
  String title;
  String image;
  String roomKey;

  ChatScreen({this.id, this.title, this.image, this.roomKey});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController controller = new TextEditingController();
  ScrollController _scrollController = new ScrollController();

  final databaseReference = FirebaseDatabase.instance.reference();

  String key = "";
  List<MessageModel> msgList = new List();
  String inputmsg;
  String msgTime;
  bool owner = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    this.getMsg(key, inputmsg);

    print("id: ${widget.id}");
    key =
        widget.id == null ? databaseReference.push().key.toString() : widget.id;
    getData();
    checkUser();
  }

  String AuthUser = null;
  void checkUser() async {
    String you = await Common.getShared(ConstKeys.firstName);
    if (you != null)
      setState(() {
        AuthUser = you;
      });
  }

  void getData() {
    var ref = FirebaseDatabase.instance.reference();
    ref
        .child("messages")
        .orderByChild("roomKey")
        .equalTo("${widget.id}")
        .onValue
        .listen((ondata) {
      // print(snapshot);
      setState(() {
        msgList = new List();
        //  loading = false;
      });
      if (ondata.snapshot != null) {
        Map<dynamic, dynamic> values = ondata.snapshot.value;
        if (values != null) {
          values.forEach((key, values) {
//            print("values $values");
            setState(() {
              msgList.add(MessageModel(
                  values["message"], values["sender"], values["time"]));
            });
          });
        } else
          print("user not found12");
//          Common.showToast("No user found");
      } else {
        print("user not found");
//        Common.showToast("Data not found");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
//    final leftOffset = -10.0;
//    final defaultIconButtonPadding = 8.0;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.video_call,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
          IconButton(
              icon: Icon(
                Icons.add_call,
                color: Colors.white,
              ),
              onPressed: () {}),
          PopupMenuButton(itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                value: 1,
                child: Text("View Contact"),
              ),
              PopupMenuItem(value: 2, child: Text("Search")),
              PopupMenuItem(
                value: 3,
                child: Text("Media"),
              ),
              PopupMenuItem(
                value: 3,
                child: Text("Mute Notification"),
              ),
              PopupMenuItem(
                value: 5,
                child: Text("Setting"),
              ),
            ];
          }),
        ],
        // centerTitle: true,
        automaticallyImplyLeading: false,
//        leading: IconButton(
//          icon: Icon(
//            Icons.arrow_back,
//            color: Colors.white,
//            // size: 12,
//          ),
//        ),
        backgroundColor: Color(0xff075e54),
        title: Container(
          // width: double.infinity,
          //color: Colors.blue,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
//                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  // size: 12,
                ),
              ),
              SizedBox(
                width: 8,
              ),
              CircleAvatar(
                  radius: 22.0,
                  child: ClipOval(
                    child: Image.network(
                      "${widget.image}",
                      fit: BoxFit.cover,
                      height: 90,
                      width: 90,
                    ),
                  )),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: Text(
                  "${widget.title}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
//
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: ListView.builder(
                    //   reverse: true,
                    itemCount: msgList.length,
                    controller: _scrollController,
                    itemBuilder: (BuildContext msg, int index) {
                      return AuthUser != null
                          ? InkWell(
                              onTap: () {},
                              child: Container(
                                //padding: EdgeInsets.all(8.0),
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: new Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    new Expanded(
                                      child: new Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
//                                          new Text("Yusra",
//                                              style: Theme.of(context)
//                                                  .textTheme
//                                                  .subhead),
                                          new Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 15),
//                                            margin: EdgeInsets.only(
//                                                right: 0, top: 8),
                                            decoration: BoxDecoration(
                                                color: Color(0xff3B6BB3),
                                                borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(15.0),
                                                  bottomLeft:
                                                      Radius.circular(15.0),
                                                  bottomRight:
                                                      Radius.circular(15.0),
                                                )),
                                            child: new Text(
                                              "${msgList.elementAt(index).msg}",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18.0),
                                            ),
                                          ),
                                          new Text(
                                              "${msgList.elementAt(index).time}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subhead),
                                        ],
                                      ),
                                    ),
                                    new Container(
                                      margin: const EdgeInsets.only(left: 16.0),
                                      child: new CircleAvatar(
                                          backgroundColor: Color(0xff3B6BB3),
                                          child: new Text(
                                            "You",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                              ))
                          : InkWell(
                              onTap: () {},
                              child: Container(
                                //padding: EdgeInsets.all(8.0),
                                margin:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                                child: new Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    new Container(
                                      margin:
                                          const EdgeInsets.only(right: 16.0),
                                      child: new CircleAvatar(
                                          backgroundColor: Colors.grey,
                                          child: new Text(
                                            "R",
//                                            "${msgList.elementAt(index).sender}",
                                            style:
                                                TextStyle(color: Colors.black),
                                          )),
                                    ),
                                    new Expanded(
                                      child: new Align(
                                        alignment: Alignment.topLeft,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
//                                            new Text("${widget.title}",
//                                                style: Theme.of(context)
//                                                    .textTheme
//                                                    .subhead),
                                            new Container(
//
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 15),
//                                              margin: EdgeInsets.only(
//                                                  right: 0, top: 8),
                                              decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(15.0),
                                                    bottomLeft:
                                                        Radius.circular(15.0),
                                                    bottomRight:
                                                        Radius.circular(15.0),
                                                  )),
                                              child: new Text(
                                                "${msgList.elementAt(index).msg}",
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    color: Colors.black87),
                                              ),
                                            ),
                                            new Text(
                                                "${msgList.elementAt(index).time}",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subhead),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ));
                    }),
              ),
            ),
            Container(
              height: 50,
              //padding: EdgeInsets.all(10.0),
              //color: Colors.purple,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.insert_emoticon,
                          color: Colors.grey,
                        ),
                        hintText: "Type Here",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),
                            borderSide:
                                BorderSide(color: Colors.white, width: 0.0)
                            //gapPadding: 50.0,
                            ),
                      ),
                      onChanged: (txt) {
                        //print("txt $txt");
                        inputmsg = txt;
                      },
                      controller: controller,
                    ),
                  ),
                  SizedBox(
                    // mhghjgjgj
                    width: 5,
                  ),
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: CircleAvatar(
                      backgroundColor: Color(0xff075e54),
                      child: IconButton(
                        color: Color(0xff3B6BB3),
                        icon: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                        onPressed: () async {
//                          var temp = await getMsg(key, inputmsg);
                          String Currenttime =
                              DateFormat('hh:mm a').format(DateTime.now());

                          String msgkey = databaseReference
                              .child("messages")
                              .push()
                              .key
                              .toString();
                          var roomMsg = {
                            "lastMsg": inputmsg,
                            "lastMsgTime": Currenttime,
                            "lastSenderName": "${widget.title}",
                            "lastSenderImage": "${widget.image}",
                          };
                          var userMsg = {
                            "message": inputmsg,
                            "time": Currenttime,
                            "sender": "${widget.title}",
                            "receiver": "sdfasfasdf",
                            "roomKey": "$key"
                          };
                          databaseReference
                              .child("chats")
                              .child(key)
                              .set(roomMsg);
                          databaseReference
                              .child("messages")
                              .child(msgkey)
                              .set(userMsg);

                          setState(() {
                            if (inputmsg == "") return;

                            if (AuthUser != null)
                              //       owner = !owner;
                              msgList.add(new MessageModel(
                                  inputmsg, "${AuthUser}", "$Currenttime"));
                            else
                              msgList.add(new MessageModel(
                                  inputmsg, widget.id, "$Currenttime"));
//                            owner = !owner;
                            AuthUser == false;
                            controller.text = "";
                            inputmsg = "";
                          });
                          _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent + 70,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeOut);
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
