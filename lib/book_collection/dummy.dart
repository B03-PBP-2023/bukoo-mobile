import 'package:flutter/material.dart';
import 'package:bukoo/book_collection/widgets/book_card.dart';

String aliceImage =
    'https://m.media-amazon.com/images/I/91ucDBkMeyL._AC_UF1000,1000_QL80_.jpg';
String aliceTitle = "Alice in Wonderland";
String aliceAuthor = "Jane Werner Watson";
BookCard alice =
    BookCard(title: aliceTitle, author: aliceAuthor, imageUrl: aliceImage);

List<Widget> bookCards = [alice, alice, alice, alice, alice];
