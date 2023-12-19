// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:bukoo/book_collection/models/book.dart';
import 'package:bukoo/core/config.dart';
import 'package:bukoo/core/etc/custom_icon_icons.dart';
import 'package:bukoo/core/widgets/custom_text_field.dart';
import 'package:bukoo/core/widgets/primary_button.dart';
import 'package:bukoo/forum/models/forum_response_model.dart';
import 'package:bukoo/forum/models/reply_model.dart';
import 'package:flutter/material.dart';
import 'package:bukoo/core/widgets/left_drawer.dart';
import 'package:bukoo/forum/models/forum_model.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:bukoo/forum/add_forum.dart';

class ForumPage extends StatefulWidget {
  final int bookId;
  const ForumPage({super.key, required this.bookId});

  @override
  State<StatefulWidget> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  Map<String, List<Reply>> forumReplies = {};
  Map<String, TextEditingController> replyControllers = {};

  Future<ForumResponseModel> fetchForums(CookieRequest request) async {
    var response =
        await request.get('$BASE_URL/api/forum/get-forum/${widget.bookId}/');

    // Melakukan konversi data json menjadi object Forum
    List<Forum> listForums = [];
    for (var forum in response['forums']) {
      listForums.add(Forum.fromJson(forum));
    }

    // Melakukan konversi data json menjadi object Book
    var bookJson = response['book'];
    Book book = Book(
        title: bookJson['title'],
        authors: bookJson['author']
            .map<String>((author) => author as String)
            .toList(),
        imageUrl: bookJson['image_url']);
    return ForumResponseModel(forums: listForums, book: book);
  }

  Future<List<Reply>> fetchReplies(CookieRequest request, int forumId) async {
    var response = await request.get('$BASE_URL/api/forum/get-reply/$forumId/');

    // Melakukan konversi data json menjadi object Reply
    List<Reply> listReplies = [];
    for (var replyData in response) {
      var reply = Reply.fromJson(replyData);
      listReplies.add(reply);
    }
    return listReplies;
  }

  void refreshReplies(CookieRequest request, int forumId) async {
    var replies = await fetchReplies(request, forumId);
    setState(() {
      replyControllers[forumId.toString()] = TextEditingController();
      forumReplies[forumId.toString()] = replies;
    });
  }

  Future<Map<String, dynamic>> addReply(
      CookieRequest request, int forumId) async {
    var response = await request.postJson(
        '$BASE_URL/api/forum/create-reply-ajax/$forumId/',
        jsonEncode({'message': replyControllers[forumId.toString()]!.text}));
    return response;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      drawer: const LeftDrawer(),
      appBar: AppBar(
          title: const Text(
            'Forum Discussion',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          )),
      body: FutureBuilder(
        future: fetchForums(request),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(children: [
                  Text(
                    snapshot.data!.book.title!,
                    style: const TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Text(snapshot.data!.book.authors!.join(', ')),
                  const SizedBox(height: 24),
                  PrimaryButton(
                      onPressed: () {Navigator.push(context,
            MaterialPageRoute(builder: (context) => ForumFormPage(bookId: widget.bookId)));
            }, child: const Text('Create New Forum')),
                  const SizedBox(height: 24),
                  ...snapshot.data!.forums.map((forum) {
                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24)),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 24,
                                      backgroundImage: NetworkImage(
                                          forum.user!.profilePic ??
                                              ProfilePictureDefault),
                                    ),
                                    const SizedBox(width: 16),
                                    Column(
                                      children: [
                                        Text(
                                          forum.user!.name!,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(timeago.format(
                                            forum.dateAdded!.toLocal())),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Text(forum.subject,
                                    style: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                Text(forum.description),
                                const SizedBox(height: 8),
                                TextButton(
                                    onPressed: () async {
                                      if (forumReplies
                                          .containsKey(forum.id.toString())) {
                                        setState(() {
                                          forumReplies
                                              .remove(forum.id.toString());
                                          replyControllers
                                              .remove(forum.id.toString());
                                        });
                                      } else {
                                        refreshReplies(request, forum.id!);
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        const Icon(CustomIcon.discussion),
                                        const SizedBox(width: 8),
                                        Text("${forum.totalReply} replies")
                                      ],
                                    ))
                              ]),
                        ),
                        const SizedBox(height: 16),
                        if (forumReplies.containsKey(forum.id.toString()))
                          Padding(
                              padding: const EdgeInsets.only(left: 32.0),
                              child: Column(children: [
                                Container(
                                    padding: const EdgeInsets.all(16.0),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(24)),
                                    child: Column(
                                      children: [
                                        CustomTextField(
                                          controller: replyControllers[
                                              forum.id.toString()]!,
                                          labelText: 'Add New Reply',
                                          minLines: 3,
                                          hintText: 'Type your reply here',
                                        ),
                                        const SizedBox(height: 8),
                                        PrimaryButton(
                                            onPressed: () async {
                                              var response = await addReply(
                                                  request, forum.id!);
                                              if (response['status'] ==
                                                  'success') {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                        content: Text(
                                                            'Reply added')));
                                                refreshReplies(
                                                    request, forum.id!);
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                        content: Text(
                                                            'Failed to add reply')));
                                              }
                                            },
                                            child: const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text('Reply'),
                                                SizedBox(width: 8),
                                                Icon(Icons.send_rounded)
                                              ],
                                            ))
                                      ],
                                    )),
                                const SizedBox(height: 16),
                                ...forumReplies[forum.id.toString()]!
                                    .expand((reply) {
                                  return [
                                    Container(
                                      padding: const EdgeInsets.all(16.0),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(24)),
                                      child: Column(children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 24,
                                              backgroundImage: NetworkImage(
                                                  reply.user!.profilePic ??
                                                      ProfilePictureDefault),
                                            ),
                                            const SizedBox(width: 16),
                                            Column(
                                              children: [
                                                Text(
                                                  reply.user!.name!,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(timeago.format(reply
                                                    .createdAt!
                                                    .toLocal())),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        Text(reply.message),
                                      ]),
                                    ),
                                    const SizedBox(height: 16)
                                  ];
                                })
                              ]))
                      ],
                    );
                  }),
                ]),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
