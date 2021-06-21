import 'dart:convert';

import 'dart:io';

import 'package:chatapp/UIPart/chatsUI/chatDetail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

String imageUrl;
File image;
User loggedInUserChat = FirebaseAuth.instance.currentUser;

class CameraView extends StatefulWidget {
  CameraView({Key key, this.path}) : super(key: key);
  final String path;

  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(icon: Icon(Icons.rotate_right_rounded), onPressed: () {}),
          IconButton(icon: Icon(Icons.emoji_emotions), onPressed: () {}),
          IconButton(icon: Icon(Icons.title), onPressed: () {}),
          IconButton(icon: Icon(Icons.edit), onPressed: () {})
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 150,
              child: Image.file(
                File(widget.path),
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 5.0,
              child: Container(
                color: Colors.black26,
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                width: MediaQuery.of(context).size.width,
                child: GestureDetector(
                  child: CircleAvatar(
                    backgroundColor: Colors.teal,
                    child: InkWell(
                      onTap: () {
                        image = File(widget.path);
                        final bytes = image.readAsBytesSync();
                        dynamic _picbyte = base64Encode(bytes);
                        FirebaseFirestore.instance
                            .collection('chatdata')
                            .doc('chatRoom')
                            .collection('chats')
                            .add(
                          {
                            'createdAt': DateTime.now().toString(),
                            'sender': loggedInUserChat.email,
                            'userId': loggedInUserChat.uid,
                            'chatMessage': _picbyte,
                            'messageType': 'Image',

                            //'messageType': 'Text'
                          },
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatDetailPage(),
                          ),
                        );
                      },
                      child: Icon(
                        Icons.check,
                      ),
                    ),
                  ),
                ),
            ),
            )],
        ),
        //Above caption we have to do things add caption
      ),
    );
  }
}
