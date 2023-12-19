class UserForum {
  int? id;
  String? name;
  String? profilePic;

  UserForum({
    this.id,
    this.name,
    this.profilePic,
  });

  factory UserForum.fromJson(Map<String, dynamic> json) => UserForum(
        id: json["id"],
        name: json["name"],
        profilePic: json["profile_pic"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "profile_pic": profilePic,
      };
}
