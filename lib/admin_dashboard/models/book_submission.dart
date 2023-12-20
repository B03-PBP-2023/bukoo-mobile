import 'package:bukoo/book_collection/models/book.dart';

class BookSubmission {
  final int id;
  final Book book;
  final String status;
  final String? feedback;
  final DateTime timestamp;

  BookSubmission({
    required this.id,
    required this.book,
    required this.status,
    this.feedback,
    required this.timestamp,
  });

  BookSubmission.fromJson(Map<String, dynamic> json)
      : id = json['pk'],
        book = Book.fromJson(json['fields']['book']),
        status = json['fields']['status'],
        feedback = json['fields']['feedback'],
        timestamp = DateTime.parse(json['fields']['timestamp']);
}
