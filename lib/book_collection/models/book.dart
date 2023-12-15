class Book {
  final int? id;
  final String? title;
  final String? imageUrl;
  final List<String>? authors;
  final String? description;
  final List<String>? genres;
  final String? publisher;
  final String? publishDate;
  final int? numPages;
  final String? language;
  final String? isbn;

  Book({
    this.id,
    this.title,
    this.imageUrl,
    this.authors,
    this.description,
    this.genres,
    this.publisher,
    this.publishDate,
    this.numPages,
    this.language,
    this.isbn,
  });

  factory Book.fromJsonDetail(Map<String, dynamic> json) {
    return Book(
      id: json['pk'],
      title: json['fields']['title'],
      imageUrl: json['fields']['image_url'],
      authors: json['fields']['author']
          .map<String>((author) => author['name'] as String)
          .toList(),
      description: json['fields']['description'],
      genres: json['fields']['genres']
          .map<String>((genre) => genre['name'] as String)
          .toList(),
      publisher: json['fields']['publisher'],
      publishDate: json['fields']['publish_date'],
      numPages: json['fields']['num_pages'],
      language: json['fields']['language'],
      isbn: json['fields']['isbn'],
    );
  }

  factory Book.fromJsonPreview(Map<String, dynamic> json) {
    return Book(
      id: json['pk'],
      title: json['fields']['title'],
      imageUrl: json['fields']['image_url'],
      authors: json['fields']['author']
          .map<String>((author) => author['name'] as String)
          .toList(),
    );
  }
}
