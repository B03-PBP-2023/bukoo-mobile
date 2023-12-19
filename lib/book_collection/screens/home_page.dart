// ignore_for_file: avoid_print

import 'package:bukoo/book_collection/models/book.dart';
import 'package:bukoo/book_collection/screens/search_page.dart';
import 'package:bukoo/book_collection/widgets/book_card.dart';
import 'package:bukoo/book_collection/widgets/scrollable_cards_wrapper.dart';
import 'package:bukoo/core/config.dart';
import 'package:bukoo/core/models/user.dart';
import 'package:bukoo/core/widgets/left_drawer.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const routeName = '/';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, List<Book>>? _books;
  bool _isLoading = false;
  String? _errorMessage;

  Future<Map<String, List<Book>>> fetchBooks() async {
    final request = Provider.of<CookieRequest>(context, listen: false);
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

  Future<void> refreshBooks() async {
    setState(() {
      _books = null;
      _isLoading = true;
    });
    try {
      final books = await fetchBooks();
      setState(() {
        _books = books;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    refreshBooks().then((value) => null);
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User>();

    return Scaffold(
      drawer: const LeftDrawer(),
      body: RefreshIndicator(
        onRefresh: refreshBooks,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
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
              flexibleSpace: LayoutBuilder(builder: (context, boxConstraint) {
                double percentExpanded =
                    (boxConstraint.maxHeight - kToolbarHeight) /
                        (200.0 - kToolbarHeight);
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      background: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Image(
                            image: AssetImage('assets/logo.png'),
                            width: 180,
                            fit: BoxFit.cover,
                          ),
                          const Text(
                            "Read More, Discover More, Be More.",
                            style: TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 16.0),
                          Text(
                            user.username != null
                                ? 'Hi ${user.name}!'
                                : 'Welcome!',
                            style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.secondary),
                          ),
                          const SizedBox(height: 64.0),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 16.0 * (1 - percentExpanded) + 4,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 3 / 4,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const SearchPage()));
                            },
                            child: AbsorbPointer(
                              child: Hero(
                                tag: 'searchBar',
                                child: SearchBar(
                                  trailing: const [Icon(Icons.search)],
                                  padding: MaterialStateProperty.all<
                                          EdgeInsetsGeometry>(
                                      const EdgeInsets.symmetric(
                                          horizontal: 16.0)),
                                  surfaceTintColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  hintText: 'Search by Title, Author, or ISBN',
                                  textStyle:
                                      MaterialStateProperty.all<TextStyle>(
                                          const TextStyle(fontSize: 14.0)),
                                  hintStyle: MaterialStateProperty.all<
                                          TextStyle>(
                                      const TextStyle(color: Colors.black26)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                );
              }),
            ),
            // const _HomePageBody()
            if (_books != null)
              SliverList(
                  delegate: SliverChildListDelegate([
                ScrollableCardsWrapper(
                  title: 'Recommendation',
                  bookCards: _books!['recommendation']!
                      .map((book) => BookCard(
                          bookId: book.id!,
                          title: book.title!,
                          author: book.authors![0],
                          imageUrl: book.imageUrl!))
                      .toList(),
                ),
                ScrollableCardsWrapper(
                  title: 'New Releases',
                  bookCards: _books!['new_releases']!
                      .map((book) => BookCard(
                          bookId: book.id!,
                          title: book.title!,
                          author: book.authors!.join(', '),
                          imageUrl: book.imageUrl ?? BookCoverDefault))
                      .toList(),
                ),
                ScrollableCardsWrapper(
                  title: 'Bahasa Indonesia',
                  bookCards: _books!['indonesian']!
                      .map((book) => BookCard(
                          bookId: book.id!,
                          title: book.title!,
                          author: book.authors![0],
                          imageUrl: book.imageUrl!))
                      .toList(),
                ),
                ScrollableCardsWrapper(
                  title: 'English',
                  bookCards: _books!['english']!
                      .map((book) => BookCard(
                          bookId: book.id!,
                          title: book.title!,
                          author: book.authors![0],
                          imageUrl: book.imageUrl!))
                      .toList(),
                ),
                ScrollableCardsWrapper(
                  title: 'Fiction',
                  bookCards: _books!['fiction']!
                      .map((book) => BookCard(
                          bookId: book.id!,
                          title: book.title!,
                          author: book.authors![0],
                          imageUrl: book.imageUrl!))
                      .toList(),
                ),
              ]))
            else if (_isLoading)
              const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_errorMessage != null)
              SliverFillRemaining(
                child: Center(
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
