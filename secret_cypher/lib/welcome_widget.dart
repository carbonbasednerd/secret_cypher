import 'package:flutter/material.dart';

class WelcomeWidget extends StatelessWidget {
  final String codeName;

  WelcomeWidget(this.codeName);

  @override
  Widget build(BuildContext context) {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Container(
            child: new Center(
                child: new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      new Text("Welcome Agent, $codeName",
                        style: new TextStyle(fontSize: 30),),
                    ]
                ))));
  }
}