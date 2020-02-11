import 'package:flutter/material.dart';
import 'package:secret_cypher/app_state.dart';
import 'package:secret_cypher/root_page.dart';
import 'package:secret_cypher/authentication.dart';
import 'package:camera/camera.dart';


Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;
  AppState().camDesc = firstCamera;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Secret Cypher',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new RootPage(auth: new Auth()));
  }
}
