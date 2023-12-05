import 'package:bukoo/book_collection/widgets/scrollable_cards_wrapper.dart';
import 'package:bukoo/core/widgets/left_drawer.dart';
import 'package:flutter/material.dart';
import 'package:bukoo/book_collection/dummy.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const routeName = '/';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const LeftDrawer(),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            stretch: true,
            onStretchTrigger: () async {
              print('Refreshed!');
            },
            // backgroundColor: Theme.of(context).primaryColor,
            expandedHeight: 200,
            flexibleSpace: const Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Hi Sofita!'),
                ]),
          ),
          const _HomePageBody()
        ],
      ),
    );
  }
}

class _HomePageBody extends StatelessWidget {
  const _HomePageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildListDelegate([
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: const Text(
          'Recommendation',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      ScrollableCardsWrapper(bookCards: bookCards),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: const Text(
          'New Release',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      ScrollableCardsWrapper(bookCards: bookCards),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: const Text(
          'Popular',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      ScrollableCardsWrapper(bookCards: bookCards),
    ]));
  }
}
