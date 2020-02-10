import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:secret_cypher/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserData extends StatefulWidget {
  UserData({this.auth, this.userId, this.updateUserCallback});

  final BaseAuth auth;
  final VoidCallback updateUserCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _UserDataState();
}

class _UserDataState extends State<UserData> {
  final _formKey = new GlobalKey<FormState>();
  final databaseReference = Firestore.instance;
  String _codeName;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Choose a Code Name'),
        ),
        body: new Container(
            padding: EdgeInsets.all(16.0),
            child: new Center(
                child: new Form(
                    key: _formKey,
                    child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          new Text(
                            "Welcome New Agent! Gotta have a code name here. What's yours going to be?",
                            style: new TextStyle(fontSize: 25),
                          ),
                          new TextFormField(
                            maxLines: 1,
                            style: new TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                            validator: (value) =>
                            value.isEmpty ? 'Agent Name can\'t be empty' : null,
                            onSaved: (value) => _codeName = value.trim(),
                          ),
                          showPrimaryButton()
                        ])))));
  }

  Widget showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.blue,
            child: new Text('Save',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: validateAndSubmit,
          ),
        ));
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() {
    if (validateAndSave()) {
      databaseReference
          .collection("users")
          .document(widget.userId)
          .updateData({'name': _codeName});

      widget.updateUserCallback();
    }
  }
}
