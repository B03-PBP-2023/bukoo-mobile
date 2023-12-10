class Genre {
  final String? name;
  final int? id;

  Genre({
    this.name,
    this.id,
  });

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      name: json['name'],
      id: json['id'],
    );
  }
}