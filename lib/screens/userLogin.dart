import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserRegister extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const UserRegister({
    Key key,
    this.scaffoldKey,
  }) : super(key: key);

  @override
  _UserRegisterState createState() => _UserRegisterState();
}

class _UserRegisterState extends State<UserRegister> {
  Map<String, TextEditingController> formControllers = {};
  Map<String, FocusNode> focusNodes = {};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autovalidate = false;

  @override
  void initState() {
    formControllers = {
      "username": TextEditingController(),
      "game_type": TextEditingController(),
      "score": TextEditingController(),
    };
    focusNodes = {
      "username": FocusNode(),
      "game_type": FocusNode(),
      "score": FocusNode(),
    };
    super.initState();
  }

  String validateEmpty(String type) {
    if (type.isEmpty) return 'Please add value to the field.';
    return null;
  }

  DocumentReference checkGameExsists(String gameType) {
    final document = Firestore.instance.collection('games').document(gameType);
    return document;
  }

  void addToDatabase(DocumentReference game) {
    game.collection("leaderboard").add({
      'username': formControllers['username'].text,
      'score': int.parse(formControllers['score'].text),
      'timestamp': DateTime.now().toIso8601String(),
    }).then((value) {
      print("Added to ${game.documentID}");
      removeFocus();
      widget.scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Added to ${game.documentID}"),
        backgroundColor: Colors.green,
      ));
    });
  }

  void removeFocus() {
    if (focusNodes["username"].hasFocus) {
      focusNodes["username"].unfocus();
    } else if (focusNodes["game_type"].hasFocus) {
      focusNodes["game_type"].unfocus();
    } else {
      focusNodes["score"].unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        autovalidate: _autovalidate,
        child: Column(
          children: <Widget>[
            TextFormField(
              focusNode: focusNodes["username"],
              controller: formControllers['username'],
              decoration: InputDecoration(
                hintText: "Enter username",
              ),
              validator: validateEmpty,
            ),
            TextFormField(
              focusNode: focusNodes["game_type"],
              controller: formControllers['game_type'],
              decoration: InputDecoration(
                hintText: "Enter game name",
              ),
              validator: validateEmpty,
            ),
            TextFormField(
              focusNode: focusNodes["score"],
              controller: formControllers['score'],
              decoration: InputDecoration(
                hintText: "Enter score",
              ),
              validator: validateEmpty,
            ),
            RaisedButton(
                child: Text("Submit"),
                onPressed: () async {
                  if (!_formKey.currentState.validate()) {
                    _autovalidate = true;
                  } else {
                    print((formControllers['username'].text));
                    print(formControllers['game_type'].text);
                    print(formControllers['score'].text);

                    var game = checkGameExsists(
                        formControllers['game_type'].text.replaceAll(RegExp(r' '), "").toLowerCase());
                    game.get().then((doc) => {
                          if (doc.exists)
                            {
                              doc.reference
                                  .collection("leaderboard")
                                  .getDocuments()
                                  .then((snapshot) {
                                if (snapshot.documents.length >= 10) {
                                  print(snapshot.documents.length);
                                  widget.scaffoldKey.currentState
                                      .showSnackBar(SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(
                                        "Max Scores are subitted! Please try different game."),
                                  ));
                                } else {
                                  addToDatabase(game);
                                }
                              }),
                            }
                          else
                            {
                              Firestore.instance
                                  .collection('games')
                                  .document(formControllers['game_type']
                                      .text
                                      .replaceAll(RegExp(r' '), "")
                                      .toLowerCase())
                                  .setData({}).then(
                                (value) => {
                                  print(
                                      "Game Added: ${formControllers['game_type'].text.toLowerCase()}"),
                                  addToDatabase(game),
                                },
                              )
                            }
                        });
                  }
                })
          ],
        ),
      ),
    );
  }
}
