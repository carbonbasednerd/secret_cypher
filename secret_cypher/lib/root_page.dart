import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:secret_cypher/app_state.dart';
import 'package:secret_cypher/authentication.dart';
import 'package:secret_cypher/login_signup_page.dart';
import 'package:secret_cypher/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:secret_cypher/user_data.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class RootPage extends StatefulWidget {
  RootPage({this.auth});

  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final databaseReference = Firestore.instance;
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  bool hasCodename = false;
  String codeName;
  String _userId = "";

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          //todo inefficient and something to be fixed
          _userId = user?.uid;
          AppState().userId = user?.uid;
        }
        authStatus =
            user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return new LoginSignupPage(
          auth: widget.auth,
          loginCallback: loginCallback,
        );
        break;
      case AuthStatus.LOGGED_IN:
        if (AppState().userId != null && AppState().userId.length > 0) {
          getUserData();
          if (hasCodename) {
            return new HomePage(
              userId: AppState().userId,
              codeName: codeName,
              auth: widget.auth,
              logoutCallback: logoutCallback,
            );
          } else {
            return new UserData(
              auth: widget.auth,
              userId: AppState().userId,
              updateUserCallback: updateUserCallBack,
            );
          }
        } else
          return buildWaitingScreen();
        break;
      default:
        return buildWaitingScreen();
    }
  }

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  void loginCallback() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
//    widget.auth.getCurrentUser().then((user) {
//      setState(() {
//
//      });
//    });
    AppState().userId = user.uid;
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
    getUserData();
  }

  void logoutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }

  void updateUserCallBack() async {
    DocumentReference docs = databaseReference.collection("users").document(AppState().userId);
    String name = "BOB";
    await docs.get().then((val) {
      if (val['name'] != '') {
        name = val['name'];
      }
    });
    setState(() {
      codeName = name;
      hasCodename = true;
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void getUserData() async {
    bool nameExists = false;
    String name;
    DocumentReference docs =
        databaseReference.collection("users").document(AppState().userId);

    await docs.get().then((val) {
      if (val['name'] != '') {
        nameExists = true;
        name = val['name'];
      }
    });
    setState(() {
      hasCodename = nameExists;
      codeName = name;
    });
  }
}
