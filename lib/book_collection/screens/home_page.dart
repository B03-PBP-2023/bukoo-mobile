import 'package:bukoo/book_collection/models/book.dart';
import 'package:bukoo/book_collection/widgets/book_card.dart';
import 'package:bukoo/book_collection/widgets/scrollable_cards_wrapper.dart';
import 'package:bukoo/core/config.dart';
import 'package:bukoo/core/models/user.dart';
import 'package:bukoo/core/widgets/left_drawer.dart';
import 'package:flutter/material.dart';
import 'package:bukoo/book_collection/dummy.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const routeName = '/';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey _searchBarKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User>();
    final request = context.watch<CookieRequest>();

    Future<Map<String, List<Book>>> fetchBooks() async {
      final response = await request.get("$BASE_URL/api/book/home/");
      final recommendation = response['recommendation']
          .map<Book>((book) => Book.fromJsonPreview(book))
          .toList();
      final newReleases = response['new_releases']
          .map<Book>((book) => Book.fromJsonPreview(book))
          .toList();
      final indonesian = response['indonesian']
          .map<Book>((book) => Book.fromJsonPreview(book))
          .toList();
      final english = response['english']
          .map<Book>((book) => Book.fromJsonPreview(book))
          .toList();
      final fiction = response['fiction']
          .map<Book>((book) => Book.fromJsonPreview(book))
          .toList();

      return {
        'recommendation': recommendation,
        'new_releases': newReleases,
        'indonesian': indonesian,
        'english': english,
        'fiction': fiction,
      };
    }

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
            collapsedHeight: 80,
            shape: const ContinuousRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(480),
                    bottomRight: Radius.circular(480))),
            onStretchTrigger: () async {
              print('Refreshed!');
            },
            flexibleSpace: Stack(
              children: [
                FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Image(
                        image: AssetImage('assets/logo.png'),
                        width: 240,
                        fit: BoxFit.cover,
                      ),
                      const Text(
                        "Read More, Discover More, Be More.",
                        style: TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        user.username != null
                            ? 'Hi ${user.username}!'
                            : 'Welcome!',
                        style: const TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 64.0),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  // padding: EdgeInsets.only(bottom: 16),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 3 / 4,
                    child: SearchBar(
                      key: _searchBarKey,
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
                  ),
                )
              ],
            ),
          ),
          // const _HomePageBody()
          FutureBuilder(
              future: fetchBooks(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SliverList(
                      delegate: SliverChildListDelegate([
                    ScrollableCardsWrapper(
                      title: 'Recommendation',
                      bookCards: snapshot.data!['recommendation']!
                          .map((book) => BookCard(
                              bookId: book.id!,
                              title: book.title!,
                              author: book.authors![0],
                              imageUrl: book.imageUrl!))
                          .toList(),
                    ),
                    ScrollableCardsWrapper(
                      title: 'New Releases',
                      bookCards: snapshot.data!['new_releases']!
                          .map((book) => BookCard(
                              bookId: book.id!,
                              title: book.title!,
                              author: book.authors![0],
                              imageUrl: book.imageUrl!))
                          .toList(),
                    ),
                    ScrollableCardsWrapper(
                      title: 'Bahasa Indonesia',
                      bookCards: snapshot.data!['indonesian']!
                          .map((book) => BookCard(
                              bookId: book.id!,
                              title: book.title!,
                              author: book.authors![0],
                              imageUrl: book.imageUrl!))
                          .toList(),
                    ),
                    ScrollableCardsWrapper(
                      title: 'English',
                      bookCards: snapshot.data!['english']!
                          .map((book) => BookCard(
                              bookId: book.id!,
                              title: book.title!,
                              author: book.authors![0],
                              imageUrl: book.imageUrl!))
                          .toList(),
                    ),
                    ScrollableCardsWrapper(
                      title: 'Fiction',
                      bookCards: snapshot.data!['fiction']!
                          .map((book) => BookCard(
                              bookId: book.id!,
                              title: book.title!,
                              author: book.authors![0],
                              imageUrl: book.imageUrl!))
                          .toList(),
                    ),
                  ]));
                } else if (snapshot.hasError) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text('${snapshot.error}'),
                    ),
                  );
                } else {
                  return SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              }),
        ],
      ),
    );
  }
}
