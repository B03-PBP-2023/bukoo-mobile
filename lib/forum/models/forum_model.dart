// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

import 'package:bukoo/forum/models/user_model.dart';

List<Forum> productFromJson(String str) =>
    List<Forum>.from(json.decode(str).map((x) => Forum.fromJson(x)));

String productToJson(List<Forum> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Forum {
  int? id;
  UserForum? user;
  DateTime? dateAdded;
  String subject;
  String description;
  int? totalReply;

  Forum({
    required this.subject,
    required this.description,
    this.id,
    this.user,
    this.dateAdded,
    this.totalReply,
  });

  factory Forum.fromJson(Map<String, dynamic> json) => Forum(
        user: UserForum.fromJson(json["user"]),
        dateAdded: DateTime.parse(json["date_added"]),
        subject: json["subject"],
        description: json["description"],
        id: json["id"],
        totalReply: json["total_reply"],
      );

  Map<String, dynamic> toJson() => {
        "subject": subject,
        "description": description,
      };
}
