import 'package:cloud_firestore/cloud_firestore.dart';

class OurUser {
  String uid;
  String email;
  String displayName;
  Timestamp createdAt;
  String groupId;

  OurUser(
      {this.uid, this.email, this.displayName, this.createdAt, this.groupId});
}
