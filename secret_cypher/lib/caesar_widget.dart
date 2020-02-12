import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'app_state.dart';

class CaesarWidget extends StatefulWidget {
  CaesarWidget();

  @override
  State<StatefulWidget> createState() => new _CaesarWidgetState();
}

class _CaesarWidgetState extends State<CaesarWidget> {
  final _formKey = new GlobalKey<FormState>();
  double sliderValue = 0;
  String decodedMessage = "";
  String originalMessage = "";
  String visionText = AppState().visionText;

//  final File imageFile = getImageFile();
//  final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(imageFile);

  @override
  Widget build(BuildContext context) {
    int roundedSliderValue = sliderValue.round();
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Container(
            child: new Center(
                child: new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
              new Text(
                "Let's code some shit!",
                style: new TextStyle(fontSize: 30),
              ),
              new Form(
                  key: _formKey,
                  child: new TextFormField(
                      initialValue: visionText,
                      minLines: null,
                      maxLines: null,
                      onSaved: (value) => originalMessage = value.trim(),
                      onChanged: updateDecodedMessage,
                      decoration: new InputDecoration(
                        hintText: 'Enter text to decode',
                      ))),
              new Slider(
                value: sliderValue,
                min: 0.0,
                max: 25.0,
                divisions: 26,
                onChanged: onSliderChanged,
              ),
              new Text("Shift Value: $roundedSliderValue"),
              new Text("Decoded Message"),
              new Text(decodedMessage),
            ]))));
  }

  updateDecodedMessage(String message) {
    setState(() {
      decodedMessage = encodeMessage(sliderValue.round(), message);
    });
  }

  onSliderChanged(double value) {
    final form = _formKey.currentState;
    form.save();
    setState(() {
      sliderValue = value.roundToDouble();
    });
    updateDecodedMessage(originalMessage);
  }

  String encodeMessage(int value, String message) {
    List<int> encodedList = [];
    for (var i = 0; i < message.length; i++) {
      int ascii = message.codeUnitAt(i);
      if (ascii >= 65 && ascii <= 90) {
        if ((ascii += value) > 90) {
          ascii = (ascii - 90) + 64;
        }
      } else if (ascii >= 97 && ascii <= 122) {
        if ((ascii += value) > 122) {
          ascii = (ascii - 122) + 96;
        }
      }
      encodedList.add(ascii);
    }
    return String.fromCharCodes(encodedList);
  }
}
