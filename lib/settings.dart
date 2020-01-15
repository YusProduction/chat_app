import 'package:flutter/material.dart';
import 'Models.dart';

class settings extends StatefulWidget {
  List<settingListModel> settingListData;
  settings({settingListData});

  @override
  _settingsState createState() => _settingsState();
}

class _settingsState extends State<settings> {
  List<settingListModel> settingListData;
//  var icon = Icons.settings;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSettingData();
  }

  void getSettingData() {
    setState(() {
      settingListData = new List();
      settingListData.add(new settingListModel(
          Icons.account_circle, "Account", "yusra@gmail.com"));
      settingListData.add(new settingListModel(
          Icons.notifications, "Notifications", "Important notifications"));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
//            color: Colors.grey,
        padding: EdgeInsets.all(6.0),
        child: ListView(
          children: <Widget>[
            Container(
//              color: Colors.blue,
              child: ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  child: Icon(
                    Icons.person_outline,
                    color: Colors.white,
                  ),
                  backgroundColor: Color(0xff075e54),
                ),
                title: Text("Profile"),
                subtitle: Text("Your Good Name"),
                onTap: () {},
              ),
            ),
            Container(
              color: Colors.grey,
              height: 1,
            ),
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: settingListData.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: CircleAvatar(
                      child: Icon(
                        settingListData.elementAt(index).icon,
                        color: Color(0xff075e54),
                      ),
//                      backgroundColor: Color(0xff075e54),
                      backgroundColor: Colors.transparent,
                    ),
                    title: Text("${settingListData.elementAt(index).account}"),
                    subtitle: Text("${settingListData.elementAt(index).email}"),
                    onTap: () {},
                  );
                }),
          ],
        ));
    ;
  }
}
