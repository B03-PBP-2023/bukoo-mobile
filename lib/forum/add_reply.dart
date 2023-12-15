import 'package:flutter/material.dart';
import 'package:bukoo/core/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:bukoo/book_collection/screens/home_page.dart';
import 'package:bukoo/forum/models/reply_model.dart';

class ReplyFormPage extends StatefulWidget {
  const ReplyFormPage({Key? key});

  @override
  State<ReplyFormPage> createState() => _ReplyFormPageState();
}

class _ReplyFormPageState extends State<ReplyFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = "";
  String _message = ""; // Menyesuaikan dengan model Product
  int _pk = 0; // Menyesuaikan dengan model Product

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: const Text(
            'Add reply',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
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
                  onChanged: (String? value) {
                    setState(() {
                      _name = value!;
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
                    hintText: "Message", // Menyesuaikan dengan model Product
                    labelText: "Message", // Menyesuaikan dengan model Product
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _message = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Message tidak boleh kosong!"; // Menyesuaikan dengan model Product
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
                      backgroundColor: MaterialStateProperty.all(Colors.purple),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Kirim ke Django dan tunggu respons
                        // DONE: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
                        final response = await request.postJson(
                          "http://127.0.0.1:8000/create-reply-flutter/",
                          jsonEncode(<String, dynamic>{
                            'user': 1, // Ganti dengan data pengguna yang sesuai (gatau bener atau salah)
                            'userName': 'Username', // Ganti dengan data pengguna yang sesuai
                            'message': _message,
                            'pk': _pk,
                          }),
                        );
                        if (response['status'] == 'success') {
                          print(response['status']);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("Reply has been saved!"),
                          ));
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("ERROR, please try again!"),
                          ));
                        }
                      }
                    },
                    child: const Text(
                      "Save",
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
