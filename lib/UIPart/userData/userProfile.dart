import 'dart:io';

import 'package:chatapp/UIPart/Group/groupAddScreen.dart';
import 'package:chatapp/UIPart/Group/showGroups.dart';
import 'package:chatapp/UIPart/chatsUI/chatsList.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile>
    with TickerProviderStateMixin {
  // User loggedInUser = FirebaseAuth.instance.currentUser;
  File image;
  final authenticator = FirebaseAuth.instance;
  TabController _tabController;
  // ignore: unused_field
  int _selectedIndex = 0;
  String urlImage;

  //
  //

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    _tabController = TabController(length: 4, vsync: this);
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

    urlImage = downloadUrl.toString();

    return urlImage;
  }

  uploadPicCamera(File image) async {
    FirebaseStorage storage = FirebaseStorage.instance;

    Reference ref =
        storage.ref().child('user_images').child(loggedInUserChat.uid + '.jpg');
    UploadTask uploadTask = ref.putFile(image);
    var downloadUrl =
        await (await uploadTask.whenComplete(() => {})).ref.getDownloadURL();

    urlImage = downloadUrl.toString();
    print(urlImage);
    return urlImage;
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
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.teal,
            title: Row(
              children: [
                Icon(Icons.verified_user),
                Text(
                  " User Profile",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabs: <Widget>[
                Tab(
                  child: TextButton(
                    child: Text(
                      'Chats',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => ChatPage()));
                    },
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
                      'User Profile',
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
                Tab(
                  child: TextButton(
                    child: Text(
                      'Calls',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),

          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                  ),
                ),
                //

                //

                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                    child: Row(
                      children: <Widget>[
                        SizedBox(width: 10),
                        Container(
                          padding: EdgeInsets.only(
                              left: 8, right: 8, top: 2, bottom: 2),
                          height: 300,
                          width: 420,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.blueAccent[50],
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Email: ',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black),
                                        ),
                                        Text(
                                          loggedInUser.email,
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    CircleAvatar(
                                      radius: 50,
                                      backgroundImage: image != null
                                          ? null
                                          : NetworkImage(
                                              "https://firebasestorage.googleapis.com/v0/b/chatapp-57f30.appspot.com/o/user_images%2F" +
                                                  loggedInUserChat.uid +
                                                  ".jpg?alt=media&token=e331836a-8159-46c6-bfaa-857ed7664b32"),
                                    ),
                                    SizedBox(height: 20),
                                    Row(
                                      children: [
                                        Text(
                                          'Update your Picture',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        ElevatedButton.icon(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.green),
                                          ),
                                          icon: Icon(Icons.photo),
                                          label: Text("Choose Image"),
                                          onPressed: showAlertDialog,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          //Bottom Navigation Bar

          // bottomNavigationBar: BottomNavigationBar(
          //   selectedItemColor: Colors.red,
          //   unselectedItemColor: Colors.red,
          //   selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
          //   unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
          //   type: BottomNavigationBarType.fixed,
          //   items: [
          //     BottomNavigationBarItem(
          //       icon: InkWell(
          //           onTap: () {
          //             Navigator.pushReplacement(context,
          //                 MaterialPageRoute(builder: (context) => ChatPage()));
          //           },
          //           child: Icon(Icons.message)),
          //       label: "Chats",
          //     ),
          //     BottomNavigationBarItem(
          //       icon: InkWell(
          //           onTap: () {}, child: Icon(Icons.supervised_user_circle)),
          //       label: "Profile",
          //     ),
          //     BottomNavigationBarItem(
          //       icon: InkWell(
          //         onTap: () async {
          //           final SharedPreferences sharedPreferences =
          //               await SharedPreferences.getInstance();
          //           sharedPreferences.remove('email');
          //           //Get.to(()
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
