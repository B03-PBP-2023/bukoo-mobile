// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

List<Reply> productFromJson(String str) =>
    List<Reply>.from(json.decode(str).map((x) => Reply.fromJson(x)));

String productToJson(List<Reply> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Reply {
  int? user;
  String? userName;
  String message;
  int? pk;

  Reply({
    required this.message,
    this.user,
    this.userName,
    this.pk,
  });

  factory Reply.fromJson(Map<String, dynamic> json) => Reply(
        user: json["user"],
        userName: json["user__name"],
        message: json["message"],
        pk: json["pk"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
      };
}
