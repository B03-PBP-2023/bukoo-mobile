import 'package:flutter/material.dart';

class User with ChangeNotifier {
  String? username;
  String? email;
  bool? isAuthor;
  bool? isAdmin;

  User({
    this.username,
    this.email,
    this.isAuthor,
    this.isAdmin,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      email: json['email'],
      isAuthor: json['is_author'],
      isAdmin: json['is_admin'],
    );
  }

  void setUser(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    isAuthor = json['is_author'];
    isAdmin = json['is_admin'];
    notifyListeners();
  }

  void resetUser() {
    username = null;
    email = null;
    isAuthor = null;
    isAdmin = null;
    notifyListeners();
  }
}
