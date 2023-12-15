import 'package:flutter/material.dart';
import 'package:bukoo/core/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:bukoo/book_collection/screens/home_page.dart';
import 'package:bukoo/forum/models/forum_model.dart';

class ForumFormPage extends StatefulWidget {
  const ForumFormPage({Key? key}) : super(key: key);

  @override
  State<ForumFormPage> createState() => _ForumFormPageState();
}

class _ForumFormPageState extends State<ForumFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _subject = "";
  String _description = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: const Text(
            'Create Forum Post',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      // Tambahkan widget form di sini
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Subject",
                    labelText: "Subject",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String value) {
                    setState(() {
                      _subject = value;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Subject tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Description",
                    labelText: "Description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String value) {
                    setState(() {
                      _description = value;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Description tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.purple),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Kirim data forum ke server atau penyimpanan
                        final forumPost = ForumPost(
                          // Ganti ini dengan cara yang sesuai untuk membuat forum post
                          subject: _subject,
                          description: _description,
                        );

                        // Selanjutnya, Anda dapat mengirim forumPost ke server atau menyimpannya.
                        // Anda dapat menggunakan kode berikut sebagai contoh:

                         final response = await request.postJson(
                             "http://127.0.0.1:8000/create-forum-flutter/",
                             jsonEncode(forumPost.toJson()));
                        //tambah apaan??
                         if (response['status'] == 'success') {
                           print(response['status']);
                           ScaffoldMessenger.of(context).showSnackBar(
                             const SnackBar(
                               content: Text("Forum post has been created!"),
                             ),
                           );
                         } else {
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
            ],
          ),
        ),
      ),
    );
  }
}


