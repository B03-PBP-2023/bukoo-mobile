// ignore_for_file: use_build_context_synchronously, prefer_final_fields

import 'package:bukoo/core/config.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:bukoo/forum/models/forum_model.dart';

class ForumFormPage extends StatefulWidget {
  final int bookId;
  const ForumFormPage({super.key, required this.bookId});

  @override
  State<ForumFormPage> createState() => _ForumFormPageState();
}

class _ForumFormPageState extends State<ForumFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = "";
  String _description = "";
  String _reply = "";

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Create a discussion',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Subject",
                  labelText: "Subject",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _name = value!;
                  });
                },
                validator: validateInput,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Description",
                  labelText: "Description",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _description = value!;
                  });
                },
                validator: validateInput,
              ),
              const SizedBox(height: 16),
              
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final response = await postItem(request);
                    if (response == 'success') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("New item has been saved!"),
                        ),
                      );
                      Navigator.pop(context); // Kembali ke halaman sebelumnya
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
        "$BASE_URL/create-flutter/",
        jsonEncode(<String, String>{
          'name': _name,
          'description': _description,
          'reply': _reply,
        }),
      );
      return response['status'];
    } catch (e) {
      return 'error';
    }
  }
}