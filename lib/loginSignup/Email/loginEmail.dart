import 'dart:async';
import 'package:chatapp/UIPart/chatsList.dart';
import 'package:chatapp/loginSignup/Google/LoginGoogle.dart';
import 'package:chatapp/loginSignup/Google/googlebutton.dart';

import 'package:chatapp/loginSignup/Email/signupEmail.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:shared_preferences/shared_preferences.dart';

class LoginEmail extends StatefulWidget {
  LoginEmail({key}) : super(key: key);
  @override
  _LoginEmailState createState() => _LoginEmailState();
}

class _LoginEmailState extends State<LoginEmail> {
  //
  //
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();
  final authenticator = FirebaseAuth.instance;
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Icon(Icons.messenger_outline),
                          Text(
                            " Hello Messenger",
                            style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: 400,
                  child: Column(
                    children: [
                      Form(
                        key: _loginFormKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 70,
                            ),
                            TextFormField(
                              controller: _emailEditingController,
                              style: TextStyle(color: Colors.black),
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Email ID',
                                hintText: 'Enter Email',
                              ),
                              onChanged: (value) {
                                email = value;
                              },
                            ),
                            TextFormField(
                              obscureText: true,
                              controller: _passwordEditingController,
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Password',
                                hintText: 'Enter your Password',
                              ),
                              onChanged: (value) {
                                password = value;
                              },
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Container(
                              height: 60,
                              width: 400,
                              child: Row(
                                children: [
                                  ElevatedButton(
                                    child: Text('Login'),
                                    onPressed: () async {
                                      final SharedPreferences
                                          sharedPreferences =
                                          await SharedPreferences.getInstance();
                                      sharedPreferences.setString(
                                          email, _emailEditingController.text);
                                      //Get.to(()
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ChatPage()));

                                      try {
                                        final user = await authenticator
                                            .signInWithEmailAndPassword(
                                                email: email,
                                                password: password);
                                        if (user != null) {
                                          Timer(
                                              Duration(seconds: 3),
                                              () =>
                                                  CircularProgressIndicator());
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ChatPage()),
                                          );
                                        }
                                      } catch (e) {
                                        print(e);
                                      }
                                    },
                                  ),
                                  Spacer(),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SignupPage()),
                                      );
                                    },
                                    child: Text(
                                      'Create Account',
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
                      SizedBox(
                        height: 30,
                        width: 40,
                      ),
                      CircleAvatar(
                        backgroundImage: AssetImage(
                          'assets/choice.png',
                        ),
                        radius: 20,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      FutureBuilder(
                        future: GoogleAuthentication.initializeFirebase(
                            context: context),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text('Error initializing Firebase');
                          } else if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return GoogleSignInButton();
                          }
                          return CircularProgressIndicator();
                        },
                      ),
                      //googleAuthBloc.googleSignin();

                      SizedBox(
                        height: 5,
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
}
