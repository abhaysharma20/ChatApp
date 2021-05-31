import 'dart:async';

import 'package:chatapp/UIPart/chatsList.dart';
import 'package:chatapp/loginSignup/Email/loginEmail.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(HomePage());
}

String finalEmail;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  final authenticate = FirebaseAuth.instance;

  void initState() {
    getValidationData().whenComplete(() async {
      //Timer(Duration(seconds: 10),
      //     () =>
      //Get.to(()
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  finalEmail == null ? LoginEmail() : ChatPage()));
    });
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  void dispose() {
    getValidationData();
    super.dispose();
  }
}
