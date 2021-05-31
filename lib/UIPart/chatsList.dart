import 'dart:io';
import 'package:chatapp/Models/chatUserModel.dart';
import 'package:chatapp/loginSignup/Email/loginEmail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'conversationList.dart';

String url;
File image;
User loggedInUserChat = FirebaseAuth.instance.currentUser;
final firestore = FirebaseFirestore.instance;

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final authenticator = FirebaseAuth.instance;
  User loggedInUser;
  String sender;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void showAlertDialog() {
    // ignore: deprecated_member_use
    Widget cameraButton = FlatButton(
      child: Text("Camera"),
      onPressed: getCameraImage,
    );
    // ignore: deprecated_member_use
    Widget galleryButton = FlatButton(
      child: Text("Gallery"),
      onPressed: getGallaryImage,
    );

    AlertDialog alert = AlertDialog(
      title: Text("Hello! "),
      content: Text("Choose Location To Import Image"),
      actions: [
        cameraButton,
        galleryButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future getCameraImage() async {
    var pictureCamera = (await ImagePicker()
        .getImage(source: ImageSource.camera, imageQuality: 100));
    if (pictureCamera != null) {
      setState(() {
        image = File(pictureCamera.path);
        //print(image.readAsBytes());
        uploadPicCamera(image);
      });
    } else {}
  }

  //Try Using Show Dialog with 2 options Cam and Gallery
  Future getGallaryImage() async {
    var pictureGallery = (await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 100));
    if (pictureGallery != null) {
      setState(() {
        image = File(pictureGallery.path);
        //image.readAsBytes();
        uploadPicGallery(image);
      });
    } else {}
  }

  uploadPicGallery(File image) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    // String url;
    Reference ref =
        storage.ref().child('user_images').child(loggedInUserChat.uid + '.jpg');
    UploadTask uploadTask = ref.putFile(image);
    var downloadUrl =
        await (await uploadTask.whenComplete(() => {})).ref.getDownloadURL();

    url = downloadUrl.toString();

    return url;
  }

  uploadPicCamera(File image) async {
    FirebaseStorage storage = FirebaseStorage.instance;

    Reference ref =
        storage.ref().child('user_images').child(loggedInUserChat.uid + '.jpg');
    UploadTask uploadTask = ref.putFile(image);
    var downloadUrl =
        await (await uploadTask.whenComplete(() => {})).ref.getDownloadURL();

    url = downloadUrl.toString();
    print(url);
    return url;
  }

// can be void too
  Future<void> getCurrentUser() async {
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

  List<ChatUsers> chatUsers = [
    ChatUsers(
        name: loggedInUserChat.email,
        messageText: 'Hello',
        imageURL:
            "https://firebasestorage.googleapis.com/v0/b/chatapp-57f30.appspot.com/o/user_images%2F" +
                loggedInUserChat.uid +
                ".jpg?alt=media&token=e331836a-8159-46c6-bfaa-857ed7664b32",
        time: ''),
  ];

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
                            " Conversations List",
                            style: TextStyle(
                                fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            left: 8, right: 8, top: 2, bottom: 2),
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.blueAccent[50],
                        ),
                        child: Row(
                          children: <Widget>[
                            GestureDetector(
                              onTap: showAlertDialog,
                              child: Hero(
                                tag: 'profilepic',
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundImage: image != null
                                      ? FileImage(image)
                                      : NetworkImage(
                                          "https://firebasestorage.googleapis.com/v0/b/chatapp-57f30.appspot.com/o/user_images%2F" +
                                              loggedInUserChat.uid +
                                              ".jpg?alt=media&token=e331836a-8159-46c6-bfaa-857ed7664b32"),
                                ),
                              ),
                            ),
                            // Text(
                            //   "Add New Chat",
                            //   style: TextStyle(
                            //       fontSize: 14, fontWeight: FontWeight.bold),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //
              //
              //Search Area For COnversations
              Padding(
                padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search for the User",
                    hintStyle: TextStyle(color: Colors.grey.shade600),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey.shade600,
                      size: 20,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: EdgeInsets.all(8),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.grey.shade100)),
                  ),
                ),
              ),

              ListView.builder(
                itemCount: chatUsers.length,
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 16),
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return ConversationList(
                    name: chatUsers[index].name,
                    messageText: chatUsers[index].messageText,
                    imageUrl: chatUsers[index].imageURL,
                    time: chatUsers[index].time,
                    //isMessageRead: (index == 0 || index == 3) ? true : false,
                  );
                },
              ),
            ],
          ),
        ),
        //
        //

        //
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.blueGrey,
          unselectedItemColor: Colors.blueGrey,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: "Chats",
            ),
            // BottomNavigationBarItem(
            //   icon: InkWell(
            //       onTap: () {
            //         Navigator.pushReplacement(context,
            //             MaterialPageRoute(builder: (context) => UserProfile()));
            //       },
            //       child: Icon(Icons.supervised_user_circle)),
            //   label: "Profile",
            // ),
            BottomNavigationBarItem(
              icon: InkWell(
                onTap: () async {
                  final SharedPreferences sharedPreferences =
                      await SharedPreferences.getInstance();
                  sharedPreferences.remove('email');

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
        ),
      ),
    );
  }
}
