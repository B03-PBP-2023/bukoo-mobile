import 'package:bukoo/core/config.dart';
import 'package:flutter/material.dart';
import 'package:bukoo/core/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:bukoo/book_collection/screens/home_page.dart';
import 'package:bukoo/forum/models/forum_model.dart';
import 'package:bukoo/forum/models/reply_model.dart';
import 'package:bukoo/core/config.dart';


class ForumFormPage extends StatefulWidget {
  int bookId;
  ForumFormPage({super.key, required this.bookId});

  @override
  State<ForumFormPage> createState() => _ForumFormPageState();
}

class _ForumFormPageState extends State<ForumFormPage> {
  final _formKey = GlobalKey<FormState>();
  // ignore: unused_field
  String _subject = "";
  String _description = "";
  String _reply = "";

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: const Text(
            'Forum Discussion',
            style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                height: 0.07),
          ),
        ),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: 390,
          height: 844,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: Color(0xFFADC4CE)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 390,
                height: 88,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 7.20,
                      offset: Offset(0, 3),
                      spreadRadius: 0,
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 248,
                height: 29,
                child: Text(
                  'Forum Discussion',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    height: 0.07,
                  ),
                ),
              ),
              Container(
                width: 342,
                height: 475,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 45.50,
                      offset: Offset(10, 21),
                      spreadRadius: -22,
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 89,
                height: 19,
                child: Text(
                  'Sofita',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w300,
                    height: 0.05,
                  ),
                ),
              ),
              Container(
                width: 320,
                height: 373,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 410,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 410,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Form(
                                  key: _formKey,
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      hintText: "Write here ...",
                                      labelText: "Write here ...",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onChanged: (String value) {
                                      setState(() {
                                        _description = value;
                                      });
                                    },
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return "Field tidak boleh kosong!";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 10),
                                  clipBehavior: Clip.antiAlias,
                                  decoration: ShapeDecoration(
                                    color: Color(0xFFF2F2F2),
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 1, color: Color(0xFFCFD4DC)),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    shadows: [
                                      BoxShadow(
                                        color: Color(0x0C101828),
                                        blurRadius: 2,
                                        offset: Offset(0, 1),
                                        spreadRadius: 0,
                                      )
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 24,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: SizedBox(
                                                  child: Text(
                                                    '$_description',
                                                    style: TextStyle(
                                                      color: Color(0xFFADC4CE),
                                                      fontSize: 16,
                                                      fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      height: 0.09,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 24,
                height: 138,
                child: Stack(children: []),
              ),
              Container(
                height: 70,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 70,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 70,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hi! Reply the discussion!',
                                  style: TextStyle(
                                    color: Color(0xFF344053),
                                    fontSize: 14,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    height: 0.10,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 10),
                                  clipBehavior: Clip.antiAlias,
                                  decoration: ShapeDecoration(
                                    color: Color(0xFFF2F2F2),
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 1, color: Color(0xFFCFD4DC)),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    shadows: [
                                      BoxShadow(
                                        color: Color(0x0C101828),
                                        blurRadius: 2,
                                        offset: Offset(0, 1),
                                        spreadRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 24,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              TextFormField(
                                                decoration: InputDecoration(
                                                  hintText:
                                                      "Write your reply here ...",
                                                  labelText:
                                                      "Write your reply here ...",
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                ),
                                                onChanged: (String value) {
                                                  setState(() {});
                                                },
                                                validator: (String? value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "Field tidak boleh kosong!";
                                                  }
                                                  return null;
                                                },
                                              ),

                                              // Tombol untuk mengirim balasan
                                              ElevatedButton(
                                                onPressed: () async {},
                                                child: const Text(
                                                  "Send Reply",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 32,
                height: 32,
                child: Stack(children: []),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.purple),
            ),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                // Validasi sukses, lakukan operasi async di sini
                final response = await postForum();
                if (response == 'success') {
                  // Tampilkan pesan sukses
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Forum post has been created!"),
                    ),
                  );
                } else {
                  // Tampilkan pesan error
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("ERROR, please try again!"),
                    ),
                  );
                }
              }
            },
            child: const Text(
              "Create Post",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  // Fungsi untuk validasi input
  String? validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return "Field tidak boleh kosong!";
    }
    return null;
  }

  // Fungsi untuk mengirim forum post ke server
  Future<String> postForum() async {
    final request = Provider.of<CookieRequest>(context, listen: false);

    try {
      // Kirim data forum ke server atau penyimpanan di sini
      final forum = Forum(subject: _subject, description: _description);
      final response = await request.postJson(
          "$BASE_URL/create-forum-flutter/", jsonEncode(forum.toJson()));
      return response['status'];
    } catch (e) {
      return 'error';
    }
  }
}
