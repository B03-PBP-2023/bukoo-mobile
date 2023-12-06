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
            backgroundColor: Theme.of(context).colorScheme.primary,
            expandedHeight: 200,
            shape: const ContinuousRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(480),
                    bottomRight: Radius.circular(480))),
            onStretchTrigger: () async {
              print('Refreshed!');
            },
            flexibleSpace:
                Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              Image(
                image: const AssetImage('assets/logo.png'),
                width: MediaQuery.of(context).size.width / 1.7,
                fit: BoxFit.cover,
              ),
              const Text(
                "Read More, Discover More, Be More.",
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Hi Sofita!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                width: MediaQuery.of(context).size.width * 3 / 4,
                child: SearchBar(
                  controller: _searchController,
                  trailing: const [Icon(Icons.search)],
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.symmetric(horizontal: 16.0)),
                  surfaceTintColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  hintText: 'Search by Title, Author, or ISBN',
                  textStyle: MaterialStateProperty.all<TextStyle>(
                      const TextStyle(fontSize: 14.0)),
                  hintStyle: MaterialStateProperty.all<TextStyle>(
                      const TextStyle(color: Colors.black26)),
                ),
              )
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
