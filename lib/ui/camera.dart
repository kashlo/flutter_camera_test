import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../services/camera_service.dart';
import '../main.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  CameraController controller;
  CameraService cameraService;

  @override
  void initState() {
    super.initState();
    getCameras();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
      ),
      body: Stack(
        children: <Widget>[
          CameraPreview(controller),
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: _captureControlRowWidget(),
          )
        ],
      ),
    );
  }

  void getCameras() async {
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    cameraService = CameraService(controller: controller, showMessage: showInSnackBar);

    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  Widget _captureControlRowWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.videocam, size: 35,),
          color: Colors.blue,
          onPressed: controller != null &&
            controller.value.isInitialized &&
            !controller.value.isRecordingVideo
            ? onVideoRecordButtonPressed
            : null,
        ),
        IconButton(
          icon: controller != null && controller.value.isRecordingPaused
            ? Icon(Icons.play_arrow, size: 35,)
            : Icon(Icons.pause, size: 35,),
          color: Colors.blue,
          onPressed: controller != null &&
            controller.value.isInitialized &&
            controller.value.isRecordingVideo
            ? (controller != null && controller.value.isRecordingPaused
            ? onResumeButtonPressed
            : onPauseButtonPressed)
            : null,
        ),
        IconButton(
          icon: const Icon(Icons.stop, size: 35,),
          color: Colors.red,
          onPressed: controller != null &&
            controller.value.isInitialized &&
            controller.value.isRecordingVideo
            ? onStopButtonPressed
            : null,
        )
      ],
    );
  }

  void onVideoRecordButtonPressed() {
    cameraService.startVideoRecording().then((String filePath) {
      if (mounted) setState(() {});
      if (filePath != null) showInSnackBar('Saving video to $filePath');
    });
  }

  void onStopButtonPressed() {
    cameraService.stopVideoRecording().then((_) {
      if (mounted) setState(() {});
    });
  }

  void onPauseButtonPressed() {
    cameraService.pauseVideoRecording().then((_) {
      if (mounted) setState(() {});
    });
  }

  void onResumeButtonPressed() {
    cameraService.resumeVideoRecording().then((_) {
      if (mounted) setState(() {});
    });
  }

  void showInSnackBar(String message) {
    print(message);
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

}
