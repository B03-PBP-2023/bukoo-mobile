// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

List<Product> productFromJson(String str) => List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
    int user;
    dynamic userName;
    String message;
    int pk;

    Product({
        required this.user,
        required this.userName,
        required this.message,
        required this.pk,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        user: json["user"],
        userName: json["user__name"],
        message: json["message"],
        pk: json["pk"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "user__name": userName,
        "message": message,
        "pk": pk,
    };
}
