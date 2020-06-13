import 'dart:convert';

Score scoreFromJson(String str) => Score.fromJson(json.decode(str));

String scoreToJson(Score data) => json.encode(data.toJson());

class Score {
    Score({
        this.score,
        this.timestamp,
        this.username,
    });

    int score;
    DateTime timestamp;
    String username;

    factory Score.fromJson(Map<String, dynamic> json) => Score(
        score: json["score"],
        timestamp: DateTime.parse(json["timestamp"]),
        username: json["username"].toString(),
    );

    Map<String, dynamic> toJson() => {
        "score": score,
        "timestamp": timestamp.toIso8601String(),
        "username": username,
    };
}
