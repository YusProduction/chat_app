import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/ChatScreen.dart';
import 'package:my_chat_app/Common.dart';
import 'Models.dart';

class NewUserChat extends StatefulWidget {
  @override
  _NewUserChatState createState() => _NewUserChatState();
}

class _NewUserChatState extends State<NewUserChat> {
  final ScrollController _scrollController = new ScrollController();
  bool loading = false;

  final databaseReference =
      FirebaseDatabase.instance.reference().child("users");
  final TextEditingController controller = new TextEditingController();

  List<MessageModel> msgList = new List();
  List<ContactModel> contactList = new List();

  void getData() async {
    setState(() {
      loading = true;
    });
    var ref = FirebaseDatabase.instance.reference();
    ref.child("users").once().then((DataSnapshot snapshot) {
      // print(snapshot);
      setState(() {
        loading = false;
      });
      if (snapshot != null) {
        Map<dynamic, dynamic> values = snapshot.value;
        if (values != null) {
          values.forEach((key, values) {
            //  print("values $values");
            setState(() {
              contactList.add(new ContactModel(values["firstName"],
                  values["lastName"], values["email"], values["phNumber"]));
            });
          });
        } else
          Common.showToast("No user found");
      } else {
        // print("user not found");
        Common.showToast("Data not found");
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select New User")),
      body: Container(
        alignment: Alignment.center,
        //padding: EdgeInsets.all(10.0),
        child: !loading
            ? contactList.length > 0
                ? ListView.builder(
                    controller: _scrollController,
                    itemCount: contactList.length,
                    itemBuilder: (BuildContext msg, int index) {
                      return InkWell(
                        child: ListTile(
                          leading: CircleAvatar(
//                        backgroundColor: Color(
//                                (Random().nextDouble() * 0xFFFFFF).toInt() << 0)
//                            .withOpacity(1.0),
                            child: Text(
                                "${contactList.elementAt(index).FirstName[0].toUpperCase()}"),
                          ),
                          title: Text(
                              "${contactList.elementAt(index).FirstName} ${contactList.elementAt(index).LastName}"),
                          subtitle:
                              Text("${contactList.elementAt(index).Email}"),
                        ),
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => new ChatScreen(
                                        id: null,
                                        title:
                                            "${contactList.elementAt(index).FirstName} ${contactList.elementAt(index).LastName}",
                                        image: "User$index",
                                      )));
                        },
                      );
                    },
                  )
                : Text("No contact found")
            : SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
