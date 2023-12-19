import 'package:bukoo/book_collection/models/book.dart';
import 'package:bukoo/core/config.dart';
import 'package:bukoo/core/etc/custom_icon_icons.dart';
import 'package:bukoo/core/widgets/primary_button.dart';
import 'package:bukoo/core/widgets/secondary_button.dart';
import 'package:bukoo/forum/forum_page.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:bukoo/review/screens/screens_page.dart';

class BookDetailPage extends StatefulWidget {
  final int bookId;
  const BookDetailPage({super.key, required this.bookId});

  static const routeName = '/book-detail';

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  static const heightOnTop = 240.0;
  static const aspectRation = 0.625;

  bool isDescriptionExpanded = false;

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    double getImageWidth() {
      return MediaQuery.of(context).size.width / 2;
    }

    double getImageHeight() {
      return getImageWidth() / aspectRation;
    }

    double getImageTop() {
      return heightOnTop - getImageHeight() / 2;
    }

    Future<Book> fetchBook() async {
      final response =
          await request.get("$BASE_URL/api/book/${widget.bookId}/");
      return Book.fromJsonDetail(response);
    }

    void onClickDiscussion(int bookId) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => ForumPage(bookId: bookId)));
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Book\'s Detail'),
        ),
        body: FutureBuilder(
          future: fetchBook(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Positioned(
                          top: 0,
                          child: Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Column(
                          children: [
                            const SizedBox(
                              height: heightOnTop,
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(64.0),
                                ),
                              ),
                              constraints: BoxConstraints(
                                minHeight: MediaQuery.of(context).size.height -
                                    heightOnTop,
                              ),
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: getImageHeight() / 2 + 16),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(snapshot.data!.title!,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w600)),
                                    ),
                                    // const SizedBox(height: 8),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                          snapshot.data!.authors!.join(', '),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium),
                                    ),
                                    const SizedBox(height: 16),
                                    SecondaryButton(
                                        onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                     ReviewPage(bookId:
                                                      snapshot.data!.id!
                                                    )));},
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(CustomIcon.review),
                                            SizedBox(width: 8),
                                            Text('See Reviews')
                                          ],
                                        )),
                                    const SizedBox(height: 16),
                                    if (request.loggedIn)
                                      Column(
                                        children: [
                                          PrimaryButton(
                                              onPressed: () {},
                                              child: const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.bookmark_border),
                                                  SizedBox(width: 8),
                                                  Text('Add to Bookmarks')
                                                ],
                                              )),
                                          const SizedBox(height: 16),
                                          PrimaryButton(
                                              onPressed: () {
                                                onClickDiscussion(
                                                    snapshot.data!.id!);
                                              },
                                              child: const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(CustomIcon.discussion),
                                                  SizedBox(width: 8),
                                                  Text('Open Discussion')
                                                ],
                                              )),
                                          const SizedBox(height: 16),
                                        ],
                                      ),

                                    const Text('Genres',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 8),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: snapshot.data!.genres!
                                            .expand((genre) => [
                                                  Chip(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              0),
                                                      label: Text(genre,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodySmall)),
                                                  const SizedBox(width: 8)
                                                ])
                                            .toList()
                                          ..removeLast(),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    const Text('Description',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 8),
                                    Text(
                                      snapshot.data!.description!,
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                      maxLines:
                                          isDescriptionExpanded ? null : 5,
                                      overflow: TextOverflow.visible,
                                    ),
                                    Align(
                                        alignment: Alignment.centerRight,
                                        child: TextButton(
                                            onPressed: () {
                                              setState(() {
                                                isDescriptionExpanded =
                                                    !isDescriptionExpanded;
                                              });
                                            },
                                            child: Text(
                                                isDescriptionExpanded
                                                    ? 'Read Less'
                                                    : 'Read More',
                                                style: const TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 12)))),
                                    const SizedBox(height: 16),
                                    const Text('Details',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 8),
                                    GridView.count(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      crossAxisCount: 2,
                                      childAspectRatio: 3,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Publisher',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12),
                                            ),
                                            Text(
                                              snapshot.data!.publisher!,
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Publish Date',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12),
                                            ),
                                            Text(
                                              snapshot.data!.publishDate!,
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Number of Pages',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12),
                                            ),
                                            Text(
                                              snapshot.data!.numPages
                                                  .toString(),
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Language',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12),
                                            ),
                                            Text(
                                              snapshot.data!.language!,
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'ISBN',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12),
                                            ),
                                            Text(
                                              snapshot.data!.isbn!,
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 16),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                            top: getImageTop(),
                            left: MediaQuery.of(context).size.width / 4,
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
                                child: Image.network(
                                  snapshot.data!.imageUrl ?? BookCoverDefault,
                                  width: getImageWidth(),
                                  height: getImageHeight(),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('ERROR: ${snapshot.error}'),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}
