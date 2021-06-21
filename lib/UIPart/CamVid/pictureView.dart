import 'dart:io';

import 'package:flutter/material.dart';

String imageUrl;
File image;

class PictureScreen extends StatefulWidget {
  PictureScreen({Key key, this.path}) : super(key: key);
  final String path;

  @override
  _PictureScreenState createState() => _PictureScreenState();
}

class _PictureScreenState extends State<PictureScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
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
                child: TextFormField(
                  maxLines: 6,
                  minLines: 1,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      hintText: ' Add Caption',
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.add_a_photo,
                        color: Colors.white,
                      ),
                      hintStyle: TextStyle(color: Colors.white, fontSize: 15),
                      suffixIcon: GestureDetector(
                        onTap: () {},
                        child: CircleAvatar(
                          backgroundColor: Colors.teal,
                          child: Icon(
                            Icons.check,
                          ),
                        ),
                      )),
                ),
              ),
            ),
          ],
        ),
        //Above caption we have to do things add caption
      ),
    );
  }
}
