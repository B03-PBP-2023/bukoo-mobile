import 'dart:convert';

class ProfileData {
  final int? id;
  final String? name;
  final String? gender;
  final DateTime? dateOfBirth;
  final String? about;
  final String? preferredGenre;
  final String? profilePictureUrl;
  final Map<String, dynamic>? statistics;

  ProfileData({
    this.id,
    this.name,
    this.gender,
    this.dateOfBirth,
    this.about,
    this.preferredGenre,
    this.profilePictureUrl,
    this.statistics,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      id: json['pk'],
      name: json['name'],
      gender: json['gender'],
      dateOfBirth: DateTime.parse(json['date_of_birth']),
      about: json['about_user'],
      preferredGenre: json['prefered_genre'],
      profilePictureUrl: json['profile_picture'],
      statistics: json['statistics'],
    );
  }
}
