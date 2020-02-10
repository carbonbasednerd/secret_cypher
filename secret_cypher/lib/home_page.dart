import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:secret_cypher/authentication.dart';

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

  @override
  void initState() {
    super.initState();
    codeName = widget.codeName;
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
          currentIndex: 0,
          items: [
            BottomNavigationBarItem(
                icon: new Icon(Icons.home),
                title: new Text("Home")
            ),
            BottomNavigationBarItem(
                icon: new Icon(Icons.message),
                title: new Text("Messages")
            ),
            BottomNavigationBarItem(
                icon: new Icon(Icons.contacts),
                title: new Text("Contacts")
            )
          ],
        ),
        body: new Container(
            padding: EdgeInsets.all(16.0),
            child: new Container(
                child: new Center(
                    child: new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          new Text("Welcome Agent, $codeName",
                          style: new TextStyle(fontSize: 30),),
                        ]
                    )))));
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
