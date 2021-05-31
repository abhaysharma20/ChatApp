import 'package:chatapp/UIPart/chatsList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

// const veryDarkBlue = Color(0xff172133);
// const kindaDarkBlue = Color(0xff202641);
final firestore = FirebaseFirestore.instance;

class ChatDetailPage extends StatefulWidget {
  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  // AudioState audioState;

  // void handleAudioState(AudioState state) {
  //   setState(() {
  //     if (audioState == null) {
  //       // Starts recording
  //       audioState = AudioState.recording;
  //       // Finished recording
  //     } else if (audioState == AudioState.recording) {
  //       audioState = AudioState.play;
  //       // Play recorded audio
  //     } else if (audioState == AudioState.play) {
  //       audioState = AudioState.stop;
  //       // Stop recorded audio
  //     } else if (audioState == AudioState.stop) {
  //       audioState = AudioState.play;
  //     }
  //   });
  // }

  final TextEditingController _textMessageController = TextEditingController();

  //ChatMessage get chatMessage => null;

  // Future uploadPicCamera(BuildContext context) async {
  //   String fileName = basename(image.path);
  //   Reference firebaseStorageRef =
  //       FirebaseStorage.instance.ref().child('uploads/$fileName');

  //   UploadTask uploadTask = firebaseStorageRef.putFile(image);
  //   url = await firebaseStorageRef.getDownloadURL();
  //   TaskSnapshot taskSnapshot = await uploadTask;
  //   taskSnapshot.ref.getDownloadURL();
  // }

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
            backgroundColor: Colors.white,
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

                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                          "https://firebasestorage.googleapis.com/v0/b/chatapp-57f30.appspot.com/o/user_images%2F" +
                              loggedInUserChat.uid +
                              ".jpg?alt=media&token=e331836a-8159-46c6-bfaa-857ed7664b32"),
                    ),
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
                                              left: 14,
                                              right: 14,
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
                                                        // (snapshot.data.docs[
                                                        //                 'index']
                                                        //             [
                                                        //             'messageType'] ==
                                                        //         'Image')
                                                        //     ? imageChat
                                                        //     :
                                                        Text(
                                                          messages,
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            color: (snapshot.data
                                                                            .docs[index]
                                                                        [
                                                                        "sender"] ==
                                                                    FirebaseAuth
                                                                        .instance
                                                                        .currentUser
                                                                        .email
                                                                ? Colors.blue
                                                                : Colors.red),
                                                          ),
                                                        ),
                                                        Text(
                                                          time,
                                                          style: TextStyle(
                                                            fontSize: 12,
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
                  height: MediaQuery.of(context).size.height * 0.08,
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
                          //Audio Message
//                           AnimatedContainer(
//                             duration: Duration(milliseconds: 300),
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: handleAudioColour(),
//                             ),
//                             child: RawMaterialButton(
//                               fillColor: Colors.white,
//                               shape: CircleBorder(),
//                               onPressed: () => handleAudioState(audioState),
//                               child: getIcon(audioState),
//                             ),
//                           ),
// //
// //
// //

//                           if (audioState == AudioState.play ||
//                               audioState == AudioState.stop)
//                             Container(
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: kindaDarkBlue,
//                               ),
//                               child: RawMaterialButton(
//                                 fillColor: Colors.white,
//                                 shape: CircleBorder(),
//                                 onPressed: () => setState(() {
//                                   audioState = null;
//                                 }),
//                                 child: Icon(Icons.replay, size: 20),
//                               ),
//                             ),

                          SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: TextFormField(
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
                            width: 10,
                          ),
                          Container(
                            height: 30,
                            width: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: RawMaterialButton(
                              fillColor: Colors.white,
                              shape: CircleBorder(),
                              onPressed: () {},
                              child: Icon(Icons.camera_alt, size: 20),
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

  Future _sendTextMessage(BuildContext context) async {
    if (_textMessageController.text != null) {
      FirebaseFirestore.instance
          .collection('chatdata')
          .doc('chatRoom')
          .collection('chats')
          .add(
        {
          'createdAt': DateTime.now().toString(),
          'userId': loggedInUserChat.uid,
          'chatMessage': _textMessageController.text,
          'sender': loggedInUserChat.email,
          'messageType': 'Text',
          //'imageUrl': url,
        },
      );
    }
    FocusScope.of(context).unfocus();
  }
}
