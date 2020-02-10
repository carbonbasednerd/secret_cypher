import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:secret_cypher/authentication.dart';
import 'package:secret_cypher/caesar_widget.dart';
import 'package:secret_cypher/welcome_widget.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.codeName, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;
  final String codeName;

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String codeName;
  int _currentIndex = 0;
  final List<Widget> _children = [];

  @override
  void initState() {
    super.initState();
    codeName = widget.codeName;
    _children.add(WelcomeWidget(codeName));
    _children.add(CaesarWidget());
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Secret Cypher'),
          actions: <Widget>[
            new FlatButton(
                child: new Text('Logout',
                    style: new TextStyle(fontSize: 17.0, color: Colors.white)),
                onPressed: signOut)
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: onNavTabTapped,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
                icon: new Icon(Icons.home),
                title: new Text("Home")
            ),
            BottomNavigationBarItem(
                icon: new Icon(Icons.message),
                title: new Text("Caesar")
            ),
//            BottomNavigationBarItem(
//                icon: new Icon(Icons.message),
//                title: new Text("M")
//            ),
//            BottomNavigationBarItem(
//                icon: new Icon(Icons.contacts),
//                title: new Text("Contacts")
//            )
          ],
        ),
        body: _children[_currentIndex]);
  }

  onNavTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }
}
