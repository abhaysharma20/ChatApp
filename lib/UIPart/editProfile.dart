/*import 'package:chatapp/UIPart/chatList.dart';
import 'package:chatapp/UIPart/userProfile.dart';
import 'package:chatapp/loginSignup/Email/loginEmail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

User loggedInUser = FirebaseAuth.instance.currentUser;

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  // final GlobalKey<FormState> _userFormKey = GlobalKey<FormState>();
  // final TextEditingController _nameEditingController = TextEditingController();
  // final TextEditingController _phoneEditingController = TextEditingController();
  final authenticator = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

//try putting await in frnt of authenticator
  Future getCurrentUser() async {
    try {
      final user = authenticator.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: Scaffold(
        drawer: Drawer(),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            " Edit User Profile Details",
                            style: TextStyle(
                                fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Center(
              //   child: Container(
              //     height: 300,
              //     width: 400,
              //     child: Column(
              //       children: [
              //         Form(
              //           key: _userFormKey,
              //           child: Column(
              //             children: [
              //               SizedBox(
              //                 height: 80,
              //               ),
              //               TextFormField(
              //                 controller: _nameEditingController,
              //                 style: TextStyle(color: Colors.black),
              //                 keyboardType: TextInputType.name,
              //                 decoration: InputDecoration(
              //                   border: UnderlineInputBorder(),
              //                   labelText: 'Name',
              //                   hintText: 'Enter Your Name',
              //                 ),
              //                 onChanged: (value) {},
              //               ),
              //               TextFormField(
              //                 obscureText: false,
              //                 controller: _phoneEditingController,
              //                 keyboardType: TextInputType.phone,
              //                 decoration: InputDecoration(
              //                   border: UnderlineInputBorder(),
              //                   labelText: 'Phone',
              //                   hintText: 'Enter your Phone Number',
              //                 ),
              //                 onChanged: (value) {},
              //               ),
              //               SizedBox(
              //                 height: 40,
              //               ),
              //               Container(
              //                 child: ElevatedButton(
              //                   child: Text('Submit Details'),
              //                   onPressed: () async {
              //                     return FirebaseFirestore.instance
              //                         .collection('userdata')
              //                         .doc(loggedInUser.toString())
              //                         .set({
              //                       'displayName': _nameEditingController.text,
              //                       'phoneNumber': _phoneEditingController.text,
              //                     });
              //                   },
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
        /* bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.blueGrey,
          unselectedItemColor: Colors.blueGrey,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => ChatPage()));
                  },
                  child: Icon(Icons.message)),
              label: "Chats",
            ),
            BottomNavigationBarItem(
              icon: InkWell(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => UserProfile()));
                  },
                  child: Icon(Icons.supervised_user_circle)),
              label: "Profile",
            ),
            BottomNavigationBarItem(
              icon: GestureDetector(child: Icon(Icons.edit)),
              label: "Edit Profile",
            ),
            BottomNavigationBarItem(
              icon: InkWell(
                onTap: () async {
                  final SharedPreferences sharedPreferences =
                      await SharedPreferences.getInstance();
                  sharedPreferences.remove('email');
                  //Get.to(()
                  authenticator.signOut();
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginEmail()));
                },
                child: Icon(Icons.logout),
              ),
              label: "Logout",
            ),
          ],
        ),*/
      ),
    );
  }
}*/
