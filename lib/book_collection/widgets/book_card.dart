import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final String title;
  final String author;
  final String imageUrl;
  final double? width;
  final double? height;
  final double aspectRatio;

  const BookCard(
      {super.key,
      required this.title,
      required this.author,
      required this.imageUrl,
      this.width,
      this.height,
      this.aspectRatio = 0.625});

  @override
  Widget build(BuildContext context) {
    double getCardWidth() {
      return (MediaQuery.of(context).size.width - 16 * 3) / 2.3;
    }

    double getCardHeight() {
      return getCardWidth() / aspectRatio + 64;
    }

    return Container(
      width: width ?? getCardWidth(),
      height: height ?? getCardHeight(),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        children: [
          Expanded(
              child: Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  spreadRadius: 2,
                  blurRadius: 6,
                  offset: const Offset(5, 5))
            ]),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                )),
          )),
          const SizedBox(height: 16.0),
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            author,
            style: const TextStyle(fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}
