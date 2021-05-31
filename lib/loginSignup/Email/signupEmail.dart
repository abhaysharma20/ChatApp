import 'dart:async';
import 'dart:io';
// ignore: unused_import
import 'dart:math';

import 'package:chatapp/loginSignup/Email/loginEmail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

String finalEmail;

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> with TickerProviderStateMixin {
  //StreamSubscription<User> loginState;

  //get googleAuthBloc => null;
  // ignore: unused_element
  void _showButtonPressDialog(BuildContext context, String provider) {
    // ignore: deprecated_member_use
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text('$provider Button Pressed!'),
      backgroundColor: Colors.black26,
      duration: Duration(milliseconds: 400),
    ));
  }

  User loggedInUserChat = FirebaseAuth.instance.currentUser;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _nameEditingController = TextEditingController();

  final TextEditingController _passwordEditingController =
      TextEditingController();
  File image;
  final authenticate = FirebaseAuth.instance;
  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.length < 8) {
      return 'Password must be longer than 8 characters';
    } else {
      return null;
    }
  }

  Future getValidationData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var getEmail = sharedPreferences.getString('email');
    if (!mounted) return;
    setState(() {
      finalEmail = getEmail;
    });
    print(finalEmail);
  }

  double _height = 50;
  double _width = 350;
  Color _color;

  void _updateState() {
    setState(() {
      _width = 250;
      _height = 100;
      _color = Colors.blue;
    });
  }

  void _returnState() {
    setState(() {
      _width = 350;
      _height = 50;
      _color = Colors.black38;
    });
  }

  AnimationController _animationController;
  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animationController.addListener(() {
      setState(() {});
    });
    _animationController.repeat();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
        // Provider(create: (context) => AuthBloc(),child:
        MaterialApp(
      theme: ThemeData.light(), // Provide light theme.
      // Provide dark theme.
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: Scaffold(
        key: _scaffoldKey,

        //
        //

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
                          Row(
                            children: [
                              Icon(Icons.switch_account),
                              Container(
                                child: Text(" Signup",
                                    style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                heightFactor: 1.0,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SafeArea(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 16, right: 16, top: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Column(
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Center(
                              heightFactor: 1.0,
                              child: Container(
                                height: 650,
                                width: 400,
                                child: Form(
                                  key: _registerFormKey,
                                  child: Column(
                                    children: [
                                      Center(
                                        // child: AnimatedBuilder(
                                        //     animation:
                                        //         _animationController.view,
                                        //     builder: (context, child) {
                                        //       return Transform.rotate(
                                        //         angle:
                                        //             _animationController.value *
                                        //                 3 *
                                        //                 pi,
                                        //         child: Container(
                                        //           child: Text(
                                        //             'Hello!',
                                        //             style: TextStyle(
                                        //                 fontSize: 50,
                                        //                 color:
                                        //                     Colors.blueAccent),
                                        //           ),
                                        //         ),
                                        //       );
                                        //     }),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                                onTap: _updateState,
                                                child: Icon(Icons.star)),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            GestureDetector(
                                              onTap: _returnState,
                                              child: AnimatedContainer(
                                                height: _height,
                                                width: _width,
                                                curve: Curves.bounceOut,
                                                color: _color,
                                                duration:
                                                    Duration(milliseconds: 200),
                                                child: Center(
                                                  child: Text(
                                                      " Welcome to Hello! ",
                                                      style: TextStyle(
                                                          fontSize: 32,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white)),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      SizedBox(
                                        height: 20,
                                      ),

                                      //Name textfield
                                      TextFormField(
                                        validator: emailValidator,
                                        obscureText: false,
                                        style: TextStyle(color: Colors.black),
                                        controller: _nameEditingController,
                                        keyboardType: TextInputType.name,
                                        decoration: InputDecoration(
                                          border: UnderlineInputBorder(),
                                          labelText: 'Name',
                                          hintText: 'Enter Your Name',
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      //email textfield
                                      TextFormField(
                                        validator: emailValidator,
                                        obscureText: false,
                                        style: TextStyle(color: Colors.black),
                                        controller: _emailEditingController,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                          border: UnderlineInputBorder(),
                                          labelText: 'E-Mail ID',
                                          hintText: 'Enter Your Email ID',
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      //password textfield
                                      TextFormField(
                                        controller: _passwordEditingController,
                                        obscureText: true,
                                        validator: pwdValidator,
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        decoration: InputDecoration(
                                          border: UnderlineInputBorder(),
                                          labelText: 'Password',
                                          hintText: 'Enter your Password',
                                        ),
                                      ),
                                      SizedBox(
                                        height: 40,
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        color: Colors.transparent,
                                        child: Row(
                                          children: [
                                            ElevatedButton(
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors.green)),
                                                child:
                                                    Text("Signup with Email"),
                                                onPressed: () async {
                                                  try {
                                                    final newUser =
                                                        await authenticate
                                                            .createUserWithEmailAndPassword(
                                                              email:
                                                                  _emailEditingController
                                                                      .text,
                                                              password:
                                                                  _passwordEditingController
                                                                      .text,
                                                            )
                                                            .then(
                                                              (currentUser) =>
                                                                  FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          "users")
                                                                      .doc(currentUser
                                                                          .user
                                                                          .displayName)
                                                                      .set({
                                                                "uid":
                                                                    currentUser
                                                                        .user
                                                                        .uid,
                                                                "email":
                                                                    _emailEditingController
                                                                        .text,
                                                                "displayName":
                                                                    _nameEditingController
                                                                        .text,
                                                                "imageUrl": "https://firebasestorage.googleapis.com/v0/b/chatapp-57f30.appspot.com/o/user_images%2F" +
                                                                    currentUser
                                                                        .user
                                                                        .uid +
                                                                    ".jpg?alt=media&token=e331836a-8159-46c6-bfaa-857ed7664b32",
                                                              }).then((result) =>
                                                                          {
                                                                            Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(builder: (context) => LoginEmail()),
                                                                            ),
                                                                          }),
                                                            );
                                                    var authResult;
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('users')
                                                        .doc(
                                                            authResult.user.uid)
                                                        .set({
                                                      'email':
                                                          _emailEditingController
                                                              .text,
                                                      "displayName":
                                                          _nameEditingController
                                                              .text,
                                                    });
                                                    if (newUser != null) {
                                                      Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                LoginEmail()),
                                                      );
                                                    }
                                                  } catch (e) {}
                                                  //}
                                                }),
                                            Spacer(),
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          LoginEmail()),
                                                );
                                              },
                                              child: Text(
                                                'Already Have an Account?',
                                              ),
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.green)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // @override
  // void dispose() {
  //   getValidationData();
  //   super.dispose();
  // }
}
