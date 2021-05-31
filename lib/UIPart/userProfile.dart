import 'dart:io';

import 'package:chatapp/UIPart/chatsList.dart';
import 'package:chatapp/loginSignup/Email/loginEmail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  User loggedInUser = FirebaseAuth.instance.currentUser;
  File image;
  final authenticator = FirebaseAuth.instance;
  final GlobalKey<FormState> _userFormKey = GlobalKey<FormState>();
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _phoneEditingController = TextEditingController();

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
      title: Text("Hello!"),
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
      //Theme
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      //home
      home: Scaffold(
        drawer: Drawer(),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                              " User Profile",
                              style: TextStyle(
                                  fontSize: 32, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                //
                //

                //Listview for Chats
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                        child: Expanded(
                          child: ListView.builder(
                            itemCount: 1,
                            //shrinkWrap: true,
                            padding: EdgeInsets.only(top: 20),
                            //physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              var userData = snapshot.data.docs[index];
                              return Card(
                                child: Column(
                                  //mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 100),
                                    Container(
                                      child: GestureDetector(
                                        onTap: showAlertDialog,
                                        child: CircleAvatar(
                                          radius: 30,
                                          backgroundImage: image == null
                                              ? NetworkImage(
                                                  "https://firebasestorage.googleapis.com/v0/b/chatapp-57f30.appspot.com/o/user_images%2F" +
                                                      loggedInUserChat.uid +
                                                      ".jpg?alt=media&token=e331836a-8159-46c6-bfaa-857ed7664b32")
                                              : FileImage(image),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: userData['displayName'] == null
                                              ? Text('Name')
                                              : Text(
                                                  "Name: " +
                                                      userData['displayName'],
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Text(
                                            "Phone Number: " +
                                                userData['phoneNumber'],
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Text(
                                            "Logged In Email: " +
                                                loggedInUser.email,
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              );
                              //
                              //
                            },
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),

                //
                //
                //Upload Data For USer
                Container(
                  height: 400,
                  width: 400,
                  child: Column(
                    children: [
                      Form(
                        key: _userFormKey,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 80,
                            ),
                            TextFormField(
                              controller: _nameEditingController,
                              style: TextStyle(color: Colors.black),
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Name',
                                hintText: 'Enter Your Name',
                              ),
                              onChanged: (value) {},
                            ),
                            TextFormField(
                              obscureText: false,
                              controller: _phoneEditingController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Phone',
                                hintText: 'Enter your Phone Number',
                              ),
                              onChanged: (value) {},
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Container(
                              child: ElevatedButton(
                                child: Text('Submit Details'),
                                onPressed: () async {
                                  return FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(loggedInUser.toString())
                                      .set({
                                    'displayName': _nameEditingController.text,
                                    'phoneNumber': _phoneEditingController.text,
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        //Bottom Navigation Bar

        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.red,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: InkWell(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => ChatPage()));
                  },
                  child: Icon(Icons.message)),
              label: "Chats",
            ),
            BottomNavigationBarItem(
              icon: InkWell(
                  onTap: () {}, child: Icon(Icons.supervised_user_circle)),
              label: "Profile",
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
        ),
      ),
    );
  }
}
