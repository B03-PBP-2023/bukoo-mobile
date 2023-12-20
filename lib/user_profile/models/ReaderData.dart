import 'dart:convert';

class ReaderData {
  final String name;
  final String gender;
  final DateTime dateOfBirth;
  final String about;
  final String preferredGenre;
  final String profilePictureUrl;

  ReaderData({
    required this.name,
    required this.gender,
    required this.dateOfBirth,
    required this.about,
    required this.preferredGenre,
    required this.profilePictureUrl,
  });

  factory ReaderData.fromJson(Map<String, dynamic> json) {
    return ReaderData(
      name: json['name'],
      gender: json['gender'],
      dateOfBirth: DateTime.parse(json['date_of_birth']),
      about: json['about'],
      preferredGenre: json['preferred_genre'],
      profilePictureUrl: json['profile_picture_url'],
    );
  }
}