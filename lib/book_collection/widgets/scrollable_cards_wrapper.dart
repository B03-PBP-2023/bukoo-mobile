import 'package:flutter/material.dart';

class ScrollableCardsWrapper extends StatelessWidget {
  final List<Widget> bookCards;
  final String title;
  const ScrollableCardsWrapper(
      {super.key, required this.bookCards, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        Scrollbar(
          radius: const Radius.circular(4.0),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: bookCards
                      .map((card) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: card,
                          ))
                      .toList(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
