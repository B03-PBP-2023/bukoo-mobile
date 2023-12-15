class User {
  String? name;
  String? username;
  String? email;
  bool? isAuthor;
  bool? isAdmin;

  User({
    this.name,
    this.username,
    this.email,
    this.isAuthor,
    this.isAdmin,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      username: json['username'],
      email: json['email'],
      isAuthor: json['is_author'],
      isAdmin: json['is_admin'],
    );
  }

  void setUser(Map<String, dynamic> json) {
    name = json['name'];
    username = json['username'];
    email = json['email'];
    isAuthor = json['is_author'];
    isAdmin = json['is_admin'];
  }

  void resetUser() {
    name = null;
    username = null;
    email = null;
    isAuthor = null;
    isAdmin = null;
  }
}
