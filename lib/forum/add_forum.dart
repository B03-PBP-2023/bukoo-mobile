// ignore_for_file: use_build_context_synchronously, prefer_final_fields

import 'package:bukoo/book_collection/models/book.dart';
import 'package:bukoo/core/config.dart';
import 'package:bukoo/core/widgets/custom_text_field.dart';
import 'package:bukoo/core/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:bukoo/forum/models/forum_model.dart';

class ForumFormPage extends StatefulWidget {
  final Book book;
  const ForumFormPage({super.key, required this.book});

  @override
  State<ForumFormPage> createState() => _ForumFormPageState();
}

class _ForumFormPageState extends State<ForumFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _subject = "";
  String _description = "";

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        title: const Center(
          child: Text('Create New Discussion',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                widget.book.title!,
                style: const TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              Text(widget.book.authors!.join(', ')),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24)),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        decoration: CustomTextField.inputDecoration.copyWith(
                          hintText: "Subject",
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            _subject = value!;
                          });
                        },
                        validator: validateInput,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: CustomTextField.inputDecoration.copyWith(
                          hintText: "Description",
                        ),
                        minLines: 5,
                        maxLines: 10,
                        onChanged: (String? value) {
                          setState(() {
                            _description = value!;
                          });
                        },
                        validator: validateInput,
                      ),
                      const SizedBox(height: 16),
                      PrimaryButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final response = await postItem(request);
                            if (response == 'success') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("New item has been saved!"),
                                ),
                              );
                              Navigator.pop(
                                  context); // Kembali ke halaman sebelumnya
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
                          "Save",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return "Field tidak boleh kosong!";
    }
    return null;
  }

  Future<String> postItem(CookieRequest request) async {
    try {
      final response = await request.postJson(
        "$BASE_URL/api/forum/create-forum-ajax/${widget.book.id}/",
        jsonEncode({
          'subject': _subject,
          'description': _description,
        }),
      );
      return response['status'];
    } catch (e) {
      return 'error';
    }
  }
}
