import 'package:flutter/cupertino.dart';

class ContactModel {
  String userId;
  String FirstName;
  String LastName;
  String Email;
  String PhoneNumber;
  ContactModel(
      this.userId, this.FirstName, this.LastName, this.Email, this.PhoneNumber);
}

class MessageModel {
  String msg;
  String sender;
  String receiver;
  String time;
  MessageModel(this.msg, this.sender, this.receiver, this.time);
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
  IconData icon;
  String account;
  String email;
  settingListModel(this.icon, this.account, this.email);
}
