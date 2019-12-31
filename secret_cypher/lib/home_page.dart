import 'dart:collection';

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
  String character = "";
  int dotDashes = 1;
  HashMap codex;

  @override
  void initState() {
    super.initState();
    message = "";
    morseCharacter = "";
    codex = generateCodex();
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
            color: Colors.cyanAccent,
            padding: EdgeInsets.all(16.0),
            child: new Container(
                color: Colors.green,
                child: new Center(
                    child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      showMessage(),
                      showMorseResults(),
                      new Container(
                        ,
                        color: Colors.brown,
                        child: showControls(),
                      )
                    ])))));
  }

  Widget showMessage() {
    return new Text(message);
  }

  Widget showMorseCharacter() {
    return new Text(morseCharacter);
  }

  Widget showCharacter() {
    return new Text(character);
  }

  Widget showMorseResults() {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        showCharacter(),
        showMorseCharacter(),
      ],
    );
  }

  Widget showControls() {
    return new Container(
        color: Colors.pink,
        child: new Row(
//      crossAxisAlignment: CrossAxisAlignment,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[telegraphKey(), enterLetterKey(), spaceKey()],
        ));
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
        onPressed: enterCharacter);
  }

  Widget spaceKey() {
    return new RaisedButton(
        elevation: 5.0,
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        color: Colors.blue,
        child: new Text("SPACE",
            style: new TextStyle(fontSize: 20.0, color: Colors.white)),
        onPressed: addSpace);
  }

  void enterCharacter() {
    setState(() {
      message += character;
      morseCharacter = "";
      dotDashes = 1;
      character = "";
    });
  }

  void updateMessage(bool isDot) {
    print("before $dotDashes");
    if (morseCharacter.length < 5) {
      setState(() {
        if (isDot) {
          morseCharacter += "*";
          dotDashes = addOne(dotDashes <<= 1);
        } else {
          morseCharacter += "-";
          dotDashes <<= 1;
        }
        print(codex.length);
        character = codex[dotDashes] ?? "";
        print("After $dotDashes");
      });
    }
  }

  static int addOne(int x) {
    int m = 1;

    // Flip all the set bits
    // until we find a 0
    while ((x & m) >= 1) {
      x = x ^ m;
      m <<= 1;
    }

    // flip the rightmost 0 bit
    x = x ^ m;
    return x;
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

  HashMap generateCodex() {
    HashMap map = new HashMap();
    map[6] = "A";
    map[23] = "B";
    map[21] = "C";
    map[11] = "D";
    map[3] = "E";
    map[29] = "F";
    map[9] = "G";
    map[31] = "H";
    map[7] = "I";
    map[24] = "J";
    map[10] = "K";
    map[27] = "L";
    map[4] = "M";
    map[5] = "N";
    map[8] = "O";
    map[25] = "P";
    map[18] = "Q";
    map[13] = "R";
    map[15] = "S";
    map[10] = "T";
    map[14] = "U";
    map[30] = "V";
    map[12] = "W";
    map[22] = "X";
    map[20] = "Y";
    map[19] = "Z";
    map[48] = "1";
    map[56] = "2";
    map[60] = "3";
    map[62] = "4";
    map[63] = "5";
    map[47] = "6";
    map[39] = "7";
    map[35] = "8";
    map[33] = "9";
    map[32] = "0";
    return map;
  }
}
