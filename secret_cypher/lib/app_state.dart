import 'package:camera/camera.dart';

class AppState {
  static final AppState _appState = AppState._internal();

  String userId;
  CameraDescription camDesc;

  factory AppState() {
    return _appState;
  }

  AppState._internal();
}