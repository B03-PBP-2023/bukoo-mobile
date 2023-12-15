// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

List<Forum> productFromJson(String str) =>
    List<Forum>.from(json.decode(str).map((x) => Forum.fromJson(x)));

String productToJson(List<Forum> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Forum {
  int? pk;
  int? user;
  String? userName;
  DateTime? dateAdded;
  String subject;
  String description;

  Forum({
    required this.subject,
    required this.description,
    this.pk,
    this.user,
    this.userName,
    this.dateAdded,
  });

  factory Forum.fromJson(Map<String, dynamic> json) => Forum(
        user: json["user"],
        userName: json["user__name"],
        dateAdded: DateTime.parse(json["date_added"]),
        subject: json["subject"],
        description: json["description"],
        pk: json["pk"],
      );

  Map<String, dynamic> toJson() => {
        "subject": subject,
        "description": description,
      };
}
