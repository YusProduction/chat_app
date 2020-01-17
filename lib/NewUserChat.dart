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

  List<ContactModel> contactList = new List();

  void getData() async {
    setState(() {
      loading = true;
    });
    String key1 = await Common.getShared(ConstKeys.userId);
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
            if (key != key1)
              setState(() {
                contactList.add(new ContactModel(
                    "$key",
                    values["firstName"],
                    values["lastName"],
                    values["email"],
                    values["phNumber"],
                    values["profileurl"]));
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

//  String profile_url = "";
//  void checkUserProfilePic() async {
//    String url = await Common.getShared(ConstKeys.profile_img);
//    if (url != null) profile_url = url;
//    print(profile_url);
//  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    checkUserProfilePic();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select New User")),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(4.0),
        child: !loading
            ? contactList.length > 0
                ? ListView.builder(
                    controller: _scrollController,
                    itemCount: contactList.length,
                    itemBuilder: (BuildContext msg, int index) {
                      return InkWell(
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 25,
                            child: contactList.elementAt(index).profilePic != ""
                                ? ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)),
                                    child: Image.network(
                                      "${contactList.elementAt(index).profilePic}",
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Text(
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
                                        user_id:
                                            contactList.elementAt(index).userId,
                                        id: null,
                                        title:
                                            "${contactList.elementAt(index).FirstName} ${contactList.elementAt(index).LastName}",
                                        image:
                                            "${contactList.elementAt(index).profilePic}",
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
