import 'package:bukoo/book_collection/models/book.dart';
import 'package:bukoo/book_collection/widgets/book_card.dart';
import 'package:bukoo/core/config.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  static const routeName = '/search';

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  List<Book> books = [];
  bool _isLoading = false;
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMore();
      }
    });
  }

  Future<List<Book>> fetchSearchData({int page = 1}) async {
    final request = context.read<CookieRequest>();
    final query = _searchController.text;
    final response =
        await request.get("$BASE_URL/api/book/?keyword=$query&page=$page");
    final books = response['data']
        .map<Book>((book) => Book.fromJsonPreview(book))
        .toList();
    setState(() {
      _page = response['page'];
    });
    return books;
  }

  void onSubmitted(String value) async {
    setState(() {
      this.books = [];
      _isLoading = true;
    });
    final books = await fetchSearchData();
    _scrollController.jumpTo(0.0);
    setState(() {
      this.books = books;
      _isLoading = false;
    });
  }

  void _loadMore() async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });

      final moreBooks = await fetchSearchData(page: _page + 1);
      if (moreBooks.isNotEmpty) {
        setState(() {
          books.addAll(moreBooks);
        });
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Theme.of(context).colorScheme.primary,
            expandedHeight: 140,
            collapsedHeight: 140,
            shape: const ContinuousRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(80),
                    bottomRight: Radius.circular(80))),
            flexibleSpace: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: Text(
                          'Search',
                          style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Hero(
                        tag: 'searchBar',
                        child: SearchBar(
                          onSubmitted: onSubmitted,
                          controller: _searchController,
                          trailing: [
                            IconButton(
                                onPressed: () {
                                  onSubmitted(_searchController.text);
                                },
                                icon: const Icon(Icons.search))
                          ],
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
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
            ),
          ),
          if (books.isEmpty && !_isLoading && _searchController.text.isNotEmpty)
            SliverFillRemaining(
              child: Center(
                child: Text(
                  'There are no books with keyword "${_searchController.text}"',
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Theme.of(context).colorScheme.secondary),
                ),
              ),
            )
          else if (books.isNotEmpty)
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.5,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  final book = books[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 16.0),
                    child: BookCard(
                      bookId: book.id!,
                      title: book.title!,
                      author: book.authors!.join(', '),
                      imageUrl: book.imageUrl ?? BookCoverDefault,
                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.width / 2 / 0.625,
                    ),
                  );
                },
                childCount: books.length,
              ),
            ),
          if (_isLoading)
            const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
