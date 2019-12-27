import 'package:flutter/material.dart';
import 'package:secret_cypher/authentication.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String message;
  String morseCharacter;


  @override
  void initState() {
    super.initState();
    message = "";
    morseCharacter = "";
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Morse'),
          actions: <Widget>[
            new FlatButton(
                child: new Text('Logout',
                    style: new TextStyle(fontSize: 17.0, color: Colors.white)),
                onPressed: signOut)
          ],
        ),
        body: new Container(
            padding: EdgeInsets.all(16.0),
            child: new Center(
                child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [showMessage(), showLetter(), showControls()]))));
  }

  Widget showMessage() {
    return new Text(message);
  }

  Widget showLetter() {
    return new Text(morseCharacter);
  }

  Widget showControls() {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          telegraphKey(),
          enterLetterKey(),
          spaceKey()
        ],
    );
  }

  Widget telegraphKey() {
    return new RaisedButton(
      elevation: 5.0,
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0)),
      color: Colors.red,
      child: new Text("DOT/DASH",
          style: new TextStyle(fontSize: 20.0, color: Colors.white)),
      onPressed: () => updateMessage(true),
      onLongPress: () => updateMessage(false),
    );
  }

  Widget enterLetterKey() {
    return new RaisedButton(
        elevation: 5.0,
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        color: Colors.blue,
        child: new Text("ENTER",
            style: new TextStyle(fontSize: 20.0, color: Colors.white)),
        onPressed: enterCharacter
    );
  }

  Widget spaceKey() {
    return new RaisedButton(
      elevation: 5.0,
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0)),
      color: Colors.blue,
      child: new Text("SPACE",
          style: new TextStyle(fontSize: 20.0, color: Colors.white)),
      onPressed: addSpace
    );
  }

  void enterCharacter() {
    setState(() {
      message += morseCharacter;
      morseCharacter = "";
    });
  }

  void updateMessage(bool isDot) {
    setState(() {
      if (isDot) {
        morseCharacter += "*";
      } else {
        morseCharacter += "-";
      }
    });
  }

  void addSpace() {
    setState(() {
      message += " ";
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
