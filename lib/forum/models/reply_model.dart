// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

import 'package:bukoo/forum/models/user_model.dart';

List<Reply> productFromJson(String str) =>
    List<Reply>.from(json.decode(str).map((x) => Reply.fromJson(x)));

String productToJson(List<Reply> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Reply {
  UserForum? user;
  String message;
  int? id;
  DateTime? createdAt;

  Reply({
    required this.message,
    this.user,
    this.id,
    this.createdAt,
  });

  factory Reply.fromJson(Map<String, dynamic> json) => Reply(
        user: UserForum.fromJson(json["user"]),
        message: json["message"],
        id: json["id"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
      };
}
