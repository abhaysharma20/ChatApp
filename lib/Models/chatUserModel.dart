import 'package:flutter/cupertino.dart';

class ChatUsers {
  String userName;
  String messageText;
  String imageURL;
  String time;
  ChatUsers(
      {@required this.userName,
      @required this.messageText,
      @required this.imageURL,
      @required this.time});
}
