class User {
  String? name;
  String? username;
  String? email;
  bool? isAuthor;
  bool? isAdmin;
  int? profileId;

  User({
    this.name,
    this.username,
    this.email,
    this.isAuthor,
    this.isAdmin,
    this.profileId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      username: json['username'],
      email: json['email'],
      isAuthor: json['is_author'],
      isAdmin: json['is_admin'],
      profileId: json['profile_id'],
    );
  }

  void setUser(Map<String, dynamic> json) {
    name = json['name'];
    username = json['username'];
    email = json['email'];
    isAuthor = json['is_author'];
    isAdmin = json['is_admin'];
    profileId = json['profile_id'];
  }

  void resetUser() {
    name = null;
    username = null;
    email = null;
    isAuthor = null;
    isAdmin = null;
    profileId = null;
  }
}
