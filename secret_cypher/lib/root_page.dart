import 'package:flutter/material.dart';
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
  String _userId = "";

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
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
        if (_userId.length > 0 && _userId != null) {
          if (hasCodename) {
            return new HomePage(
              userId: _userId,
              auth: widget.auth,
              logoutCallback: logoutCallback,
            );
          } else {
            return new UserData(
              auth: widget.auth,
              userId: _userId,
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

  void loginCallback() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
    getUserData(_userId);
  }

  void logoutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }

  void updateUserCallBack() {
    setState(() {
      hasCodename = true;
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void getUserData(String id) {
    bool nameExists = false;
    databaseReference.collection("users")
        .document(id)
        .get().then((val){
          if (val['name'] != ''){
            nameExists = true;
          }
        }
    );
    setState(() {
      hasCodename = nameExists;
    });
  }
}
