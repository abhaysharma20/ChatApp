import 'dart:convert';
import 'dart:typed_data';

import 'package:chatapp/Models/chatMessageModel.dart';
import 'package:chatapp/UIPart/CamVid/cameraScreen.dart';
import 'package:chatapp/UIPart/Group/groupAddScreen.dart';
import 'package:chatapp/UIPart/chatsUI/chatsList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final firestore = FirebaseFirestore.instance;

// ignore: must_be_immutable
class ChatDetailPage extends StatefulWidget {
  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
  String uuuuu;
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _textMessageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: Scaffold(
          appBar: AppBar(
            brightness: Brightness.dark,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.teal[700],
            flexibleSpace: SafeArea(
              child: Container(
                padding: EdgeInsets.only(right: 16),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatPage()));
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                    ),

                    SizedBox(
                      width: 2,
                    ),

                    Spacer(),
                    Icon(Icons.call),
                    SizedBox(
                      width: 20,
                    ),
                    Icon(Icons.video_call),

                    SizedBox(
                      width: 12,
                    ),

                    //Input TItle for User
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            )),
                        SizedBox(
                          height: 6,
                        ),
                        /*Text(
                          "Online",
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 13),
                        ),*/
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          //

          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height * 0.85,
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('chatdata')
                              .doc('chatRoom')
                              .collection('chats')
                              .orderBy('createdAt', descending: true)
                              .snapshots(),
                          builder: (BuildContext context, snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                reverse: true,
                                itemCount: snapshot.data.docs.length,

                                //chats ke upar neeche ka space
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                itemBuilder: (context, index) {
                                  var messages =
                                      snapshot.data.docs[index]['chatMessage'];
                                  var time =
                                      snapshot.data.docs[index]['createdAt'];

                                  ChatMessage object = ChatMessage();
                                  if (snapshot.data.docs[index]
                                          ['messageType'] ==
                                      'Image') {
                                    Uint8List imageList = base64Decode(snapshot
                                        .data.docs[index]['chatMessage']);
                                    object.img = Image.memory(
                                      imageList,
                                      fit: BoxFit.cover,
                                    );
                                  }

                                  //Bottom container is for showing messages
                                  return Row(
                                    mainAxisAlignment: snapshot.data.docs[index]
                                                ["sender"] ==
                                            FirebaseAuth
                                                .instance.currentUser.email
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              left: 20,
                                              right: 10,
                                              top: 10,
                                              bottom: 10),
                                          child: Align(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),

                                              //Design Chats
                                              child: Material(
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(50.0),
                                                    bottomRight:
                                                        Radius.circular(50.0),
                                                    bottomLeft:
                                                        Radius.circular(50.0)),

                                                // Show Text
                                                child: Row(
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        (snapshot.data.docs[
                                                                        index][
                                                                    'messageType'] ==
                                                                'Image')
                                                            ? Container(
                                                                //ImageContainer
                                                                child:
                                                                    GestureDetector(
                                                                  onTap:
                                                                      openImage,
                                                                  child: object
                                                                      .img,
                                                                ),
                                                                height: 150,
                                                                width: 150,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .black12),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              30),
                                                                ),
                                                              )
                                                            : Container(
                                                                //Message Container
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: snapshot.data.docs[index]
                                                                              [
                                                                              "sender"] ==
                                                                          FirebaseAuth
                                                                              .instance
                                                                              .currentUser
                                                                              .email
                                                                      ? Colors.teal[
                                                                          200]
                                                                      : Colors
                                                                          .black12,
                                                                  borderRadius: BorderRadius.only(
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              50.0),
                                                                      bottomRight:
                                                                          Radius.circular(
                                                                              50.0),
                                                                      bottomLeft:
                                                                          Radius.circular(
                                                                              50.0)),
                                                                ),
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            15),
                                                                child: Column(
                                                                  children: [
                                                                    // Positioned(
                                                                    //   bottom: 5,
                                                                    //   right: 5,
                                                                    //   left: 0,
                                                                    //   top: 10,
                                                                    //   child:
                                                                    //       CircleAvatar(
                                                                    //     radius:
                                                                    //         11,
                                                                    //     child: Icon(
                                                                    //         Icons
                                                                    //             .check,
                                                                    //         color:
                                                                    //             Colors.white,
                                                                    //         size: 18),
                                                                    //   ),
                                                                    // ),
                                                                    Text(
                                                                      messages,
                                                                      maxLines:
                                                                          1,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            20,
                                                                      ),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .clip,
                                                                      softWrap:
                                                                          true,
                                                                    ),
                                                                    Text(
                                                                      time,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else
                              return Center(child: CircularProgressIndicator());
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                //
                //

                Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                      height: MediaQuery.of(context).size.height,
                      width: double.infinity,
                      color: Colors.white,
                      child: Row(
                        children: <Widget>[
                          //

                          SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: TextFormField(
                              maxLines: 10,
                              minLines: 1,
                              onChanged: (value) {
                                setState(() {});
                              },
                              style: TextStyle(),
                              controller: _textMessageController,
                              decoration: InputDecoration(
                                  hintText: ("Write message..."),
                                  hintStyle: TextStyle(
                                      color: Colors.black54, fontSize: 17),
                                  border: InputBorder.none),
                            ),
                          ),
                          SizedBox(
                            width: 0,
                          ),
                          Container(
                            height: 30,
                            width: 100,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.blueGrey),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RawMaterialButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                        elevation: 30,
                                        isScrollControlled: true,
                                        isDismissible: true,
                                        enableDrag: true,
                                        backgroundColor: Colors.transparent,
                                        context: context,
                                        builder: (builder) => bottomSheet());
                                  },
                                  child: Icon(Icons.attachment),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: Colors.lightBlue,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: GestureDetector(
                              onTap: () async {
                                await _sendTextMessage(context);

                                _textMessageController.clear();
                              },
                              child: Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget openImage() {
    return Container();
  }

  Widget bottomSheet() {
    return Container(
      height: 270,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: EdgeInsets.all(20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(35.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CameraScreen()));
                    },
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.blueAccent[100],
                      child: Icon(
                        Icons.camera_alt,
                        size: 50,
                        color: Colors.blueAccent[600],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.blueGrey[200],
                    child: Icon(
                      Icons.image,
                      size: 50,
                      color: Colors.blueGrey,
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  CircleAvatar(
                      backgroundColor: Colors.purpleAccent,
                      radius: 28,
                      child: Icon(Icons.audiotrack,
                          size: 50, color: Colors.purple)),
                  SizedBox(
                    width: 30,
                  ),
                  CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.green[200],
                      child: Icon(Icons.location_on,
                          size: 50, color: Colors.green)),
                ],
              ),
            ),
            SizedBox(
              width: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.tealAccent[200],
                  child: Icon(
                    Icons.file_copy,
                    size: 50,
                    color: Colors.teal,
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                CircleAvatar(
                    backgroundColor: Colors.orangeAccent[100],
                    radius: 28,
                    child: Icon(Icons.payment, size: 50, color: Colors.orange)),
                SizedBox(
                  width: 30,
                ),
                CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.green[200],
                    child: Icon(Icons.contact_page_outlined,
                        size: 50, color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future _sendTextMessage(BuildContext context) async {
    if (_textMessageController.text != null) {
      FirebaseFirestore.instance
          .collection('chatdata')
          .doc('chatRoom')
          .collection('chats')
          .add(
        {
          'createdAt': DateTime.now().toString(),
          'userId': loggedInUser.uid,
          'chatMessage': _textMessageController.text,
          'sender': loggedInUser.email,
          'messageType': 'Text',
        },
      );
    }
    FocusScope.of(context).unfocus();
  }
}
