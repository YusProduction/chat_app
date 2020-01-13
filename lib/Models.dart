import 'package:flutter/cupertino.dart';

class ContactModel {
  String FirstName;
  String LastName;
  String Email;
  String PhoneNumber;
  ContactModel(this.FirstName, this.LastName, this.Email, this.PhoneNumber);
}

class MessageModel {
  String msg;
  String sender;
  String time;
  MessageModel(this.msg, this.sender, this.time);
}

class UsersLastMsg {
  String id;
  String lastMsg;
  String lastMsgTime;
  String lastSenderName;
  String lastSenderImage;
  String firstName;
  UsersLastMsg(this.id, this.lastMsg, this.lastMsgTime, this.lastSenderName,
      this.lastSenderImage, this.firstName);
}

class settingListModel {
  Icon icon;
  String account;
  String email;
  settingListModel({this.icon,this.account, this.email});
}
