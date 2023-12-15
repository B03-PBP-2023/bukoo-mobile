import 'package:bukoo/book_collection/models/book.dart';
import 'package:bukoo/forum/models/forum_model.dart';

class ForumResponseModel {
  List<Forum> forums;
  Book book;  

  ForumResponseModel({
    required this.forums,
    required this.book,
  });
}
