// import 'dart:math';

// import 'package:cloud_firestore/cloud_firestore.dart';

// class DatabaseMethods {
//   getUserByUserName(String username) {
//     FirebaseFirestore.instance
//         .collection('users')
//         .where("displayName", isEqualTo: username)
//         .get();
//   }

//   uploadUserInfo(userMap) {
//     FirebaseFirestore.instance.collection('users').add(userMap).catchError((e) {
//       print(e.toString());
//     });
//   }
// }
