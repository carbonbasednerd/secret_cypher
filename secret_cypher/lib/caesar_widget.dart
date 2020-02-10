import 'package:flutter/material.dart';

class CaesarWidget extends StatelessWidget {

  CaesarWidget();

  @override
  Widget build(BuildContext context) {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Container(
            child: new Center(
                child: new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      new Text("Let's code some shit!",
                        style: new TextStyle(fontSize: 30),),
                    ]
                ))));
  }
}