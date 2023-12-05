import 'package:flutter/material.dart';

class ScrollableCardsWrapper extends StatelessWidget {
  final List<Widget> bookCards;
  const ScrollableCardsWrapper({super.key, required this.bookCards});

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
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
    );
  }
}
