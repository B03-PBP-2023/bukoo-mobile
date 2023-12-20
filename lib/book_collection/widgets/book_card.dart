import 'package:bukoo/book_collection/screens/book_detail_page.dart';
import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final int bookId;
  final String title;
  final String author;
  final String imageUrl;
  final double? width;
  final double? height;
  final double aspectRatio;

  const BookCard(
      {super.key,
      required this.bookId,
      required this.title,
      required this.author,
      required this.imageUrl,
      this.width,
      this.height,
      this.aspectRatio = 0.625});

  @override
  Widget build(BuildContext context) {
    double getCardWidth() {
      if (width != null) return width!;
      return (MediaQuery.of(context).size.width - 16 * 3) / 2.3;
    }

    double getCardHeight() {
      if (width != null && height != null) return height!;
      if (width != null) return width! / aspectRatio + 64;
      return getCardWidth() / aspectRatio + 64;
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return BookDetailPage(
            bookId: bookId,
          );
        }));
      },
      child: Container(
        width: getCardWidth(),
        height: getCardHeight(),
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.max,
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
            Container(
              alignment: Alignment.center,
              height: (14.0 * 2) + 12,
              child: Text(
                title,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              author,
              style: const TextStyle(fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ),
    );
  }
}
