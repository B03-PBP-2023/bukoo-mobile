import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  final String? query;
  const SearchPage({super.key, this.query});

  static const routeName = '/search';

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final _searchBarKey = GlobalKey();

  @override
  void initState() {
    _searchController.text = widget.query != null ? widget.query! : '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            stretch: true,
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
                      SearchBar(
                        onSubmitted: (value) {},
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
                      )
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
