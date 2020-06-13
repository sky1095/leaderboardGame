import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:leaderboardapp/models/scores.dart';

class LeaderBoardScreen extends StatefulWidget {
  final Query collectionReference;
  final String game;

  LeaderBoardScreen({this.collectionReference, this.game});
  @override
  _LeaderBoardScreenState createState() => _LeaderBoardScreenState();
}

class _LeaderBoardScreenState extends State<LeaderBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Leaderboard for ${widget.game}"),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: widget.collectionReference.getDocuments(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return ListView.separated(
                itemBuilder: (context, index) {
                  Score score = scoreFromJson(
                      json.encode(snapshot.data.documents[index].data));

                  return ListTile(

                    leading: CircleAvatar(child: Text("${index+1}")),
                    title: Text(score.username),
                    trailing: Text(score.score.toString()),
                    subtitle:
                        Text("Submitted on ${DateFormat("MMM d, yyyy 'at' h:mm a").format(score.timestamp)}"),
                  );
                },
                separatorBuilder: (context, index) => Divider(),
                itemCount: snapshot.data.documents.length,
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
