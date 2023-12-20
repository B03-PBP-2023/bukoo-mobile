import 'package:flutter/material.dart';

class ScrollableCardsWrapper extends StatefulWidget {
  final List<Widget> bookCards;
  final String title;
  const ScrollableCardsWrapper(
      {super.key, required this.bookCards, required this.title});

  @override
  State<ScrollableCardsWrapper> createState() => _ScrollableCardsWrapperState();
}

class _ScrollableCardsWrapperState extends State<ScrollableCardsWrapper> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            widget.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        Scrollbar(
          controller: _scrollController,
          radius: const Radius.circular(4.0),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: _scrollController,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: widget.bookCards
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
