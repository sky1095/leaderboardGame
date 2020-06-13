import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:leaderboardapp/screens/leaderboardScreen.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: StreamBuilder(
            stream: Firestore.instance.collection('games').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return GridView.builder(
                  itemCount: snapshot.data.documents.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => LeaderBoardScreen(
                            collectionReference: snapshot
                                .data.documents[index].reference
                                .collection("leaderboard")
                                .orderBy("score", descending: true),
                            game: snapshot.data.documents[index].documentID,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      child: Center(
                        child: Text(snapshot.data.documents[index].documentID),
                      ),
                    ),
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}
