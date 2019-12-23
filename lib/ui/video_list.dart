import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'camera.dart';

class VideoListScreen extends StatefulWidget {

  @override
  _VideoListScreenState createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  List<FileSystemEntity> files = [];
  Future<Directory> appDocumentsDirectory;

  @override
  void initState() {
    requestAppDocumentsDirectory();
    super.initState();
  }

  Widget buildDirectory(
      BuildContext context, AsyncSnapshot<Directory> snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      if (snapshot.hasError) {
      } else if (snapshot.hasData) {
        Directory("${snapshot.data.path}/Movies/").createSync(recursive: true);

        files = Directory("${snapshot.data.path}/Movies/").listSync();
      } else {
        print("Error: Path unavailable");
      }
    }
    return ListView(
      children: files.map((FileSystemEntity file) {
        return ListTile(title: Text(file.toString()));
      }).toList()
    );
  }

  void requestAppDocumentsDirectory() {
      appDocumentsDirectory = getApplicationDocumentsDirectory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: Icon(Icons.add,),
        onPressed: openCameraScreen,
      ),
      appBar: AppBar(
        title: Text("Video list"),
      ),
      body: FutureBuilder<Directory>(future: appDocumentsDirectory, builder: buildDirectory),
    );
  }

  void openCameraScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => CameraScreen()));
  }
}
