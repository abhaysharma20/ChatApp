import 'package:chatapp/UIPart/CamVid/cameraView.dart';
import 'package:chatapp/UIPart/chatsUI/chatDetail.dart';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

List<CameraDescription> cameras = [];

class GroupCameraScreen extends StatefulWidget {
  // GroupCameraScreen(this.grpname);
  @override
  _GroupCameraScreenState createState() => _GroupCameraScreenState();
  // String grpname;
}

class _GroupCameraScreenState extends State<GroupCameraScreen> {
  CameraController _cameraController;

  Future<void> cameraValue;
  @override
  void initState() {
    super.initState();
    _cameraController = CameraController(cameras[0], ResolutionPreset.high);

    cameraValue = _cameraController.initialize();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
            child: Container(
                padding: EdgeInsets.only(right: 16),
                child: Row(children: <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatDetailPage()));
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                ]))),
      ),
      body: Stack(
        children: [
          FutureBuilder(
            future: cameraValue,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CameraPreview(_cameraController);
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          Positioned(
            bottom: 0.0,
            child: Container(
              padding: EdgeInsets.only(top: 5, bottom: 5),
              color: Colors.black38,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          icon: Icon(
                            Icons.flash_off,
                            size: 30,
                            color: Colors.white,
                          ),
                          onPressed: () {}),
                      InkWell(
                        child: Icon(
                          Icons.panorama_fish_eye,
                          size: 70,
                          color: Colors.white,
                        ),
                        onTap: () {
                          takePhoto(context);
                        },
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.flip_camera_ios,
                            size: 30,
                            color: Colors.white,
                          ),
                          onPressed: () {}),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Tap for Photo',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void takePhoto(context) async {
    final path =
        join((await getTemporaryDirectory()).path, "${DateTime.now()}.png");
    XFile picture = await _cameraController.takePicture();
    picture.saveTo(path);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraView(
          path: path,
        ),
      ),
    );
    print(path);
  }
}
