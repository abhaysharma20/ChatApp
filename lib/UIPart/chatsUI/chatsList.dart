import 'dart:io';
import 'dart:ui';
import 'package:chatapp/UIPart/Group/groupAddScreen.dart';
import 'package:chatapp/UIPart/Group/showGroups.dart';
import 'package:chatapp/UIPart/chatsUI/chatDetail.dart';
import 'package:chatapp/UIPart/userData/userProfile.dart';
import 'package:chatapp/loginSignup/Email/loginEmail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

String url;
File image;

final firestore = FirebaseFirestore.instance;

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final authenticator = FirebaseAuth.instance;
  User loggedInUser;
  String sender;
  TabController _tabController;
  int _selectedIndex = 0;
  //
  //
  @override
  void initState() {
    super.initState();
    getCurrentUser();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
      print("Selected Index: " + _tabController.index.toString());
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          drawer: Drawer(
            child: Column(
              children: [
                Container(
                  height: 100,
                ),
                Column(
                  children: [
                    Text(
                      'Logged-In Email: ',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    Text(
                      loggedInUser.email,
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: image != null
                          ? null
                          : NetworkImage(
                              "https://firebasestorage.googleapis.com/v0/b/chatapp-57f30.appspot.com/o/user_images%2F" +
                                  loggedInUserChat.uid +
                                  ".jpg?alt=media&token=e331836a-8159-46c6-bfaa-857ed7664b32"),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    ElevatedButton.icon(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.green),
                      ),
                      icon: Icon(Icons.photo),
                      label: Text("Choose Image"),
                      onPressed: showAlertDialog,
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Logout',
                    ),
                    IconButton(
                      iconSize: 36,
                      tooltip: 'Logout',
                      onPressed: () async {
                        final SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                        sharedPreferences.remove('email');

                        authenticator.signOut();
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginEmail()));
                      },
                      icon: Icon(Icons.logout),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ],
            ),
          ),
          appBar: AppBar(
            backgroundColor: Colors.teal[700],
            title: Text(
              " WhatsApp",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorWeight: 2,
              indicatorColor: Colors.white,
              tabs: <Widget>[
                Tab(
                  child: TextButton(
                    child: Text(
                      'Chats',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {},
                  ),
                ),
                Tab(
                  child: TextButton(
                    child: Text(
                      'Group',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ShowGroups()));
                    },
                  ),
                ),
                Tab(
                  child: TextButton(
                    child: Text(
                      'Calls',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserProfile()));
                    },
                  ),
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                    child: Row(
                      children: <Widget>[
                        SizedBox(width: 10),
                        Container(
                          padding: EdgeInsets.only(
                              left: 8, right: 8, top: 2, bottom: 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.blueAccent[50],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //
                //
                //Search Area For COnversations

                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .orderBy('userName')
                      .snapshots(),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.only(top: 10),
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          DocumentSnapshot cuteUsers =
                              snapshot.data.docs[index];
                          return Container(
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: InkWell(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ChatDetailPage())),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(cuteUsers['imageUrl']),
                                      ),
                                      SizedBox(width: 20),
                                      Text(cuteUsers['userName']),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return Container();
                  },
                ),
              ],
            ),
          ),
          //
          //

          //
          // bottomNavigationBar: BottomNavigationBar(
          //   selectedItemColor: Colors.blueGrey,
          //   unselectedItemColor: Colors.blueGrey,
          //   selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
          //   unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
          //   type: BottomNavigationBarType.fixed,
          //   items: [
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.message),
          //       label: "Chats",
          //     ),
          //     BottomNavigationBarItem(
          //       icon: InkWell(
          //           onTap: () {
          //             Navigator.pushReplacement(
          //                 context,
          //                 MaterialPageRoute(
          //                     builder: (context) => GroupAddScreen()));
          //           },
          //           child: Icon(Icons.group)),
          //       label: "Groups",
          //     ),
          //     BottomNavigationBarItem(
          //       icon: InkWell(
          //         onTap: () async {
          //           final SharedPreferences sharedPreferences =
          //               await SharedPreferences.getInstance();
          //           sharedPreferences.remove('email');

          //           authenticator.signOut();
          //           Navigator.pop(context);
          //           Navigator.push(context,
          //               MaterialPageRoute(builder: (context) => LoginEmail()));
          //         },
          //         child: Icon(Icons.logout),
          //       ),
          //       label: "Logout",
          //     ),
          //   ],
          // ),
        ),
      ),
    );
  }
}
