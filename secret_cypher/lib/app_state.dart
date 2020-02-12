import 'package:camera/camera.dart';

class AppState {
  static final AppState _appState = AppState._internal();

  String userId;
  CameraDescription camDesc;
  String visionText;

  factory AppState() {
    return _appState;
  }

  AppState._internal();
}