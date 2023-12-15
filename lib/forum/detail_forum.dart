import 'package:flutter/material.dart';
import 'package:bukoo/forum/models/forum_model.dart';

class DetailForumPage extends StatelessWidget {
  final Product item;

  DetailForumPage({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          item.subject, // Menggunakan subject dari model Product
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              item.subject, // Menggunakan subject dari model Product
              style: Theme.of(context).textTheme.headline6, // Menggunakan gaya teks yang sesuai
            ),

            const SizedBox(height: 10),
            Text("User : ${item.userName}"),
            const SizedBox(height: 10),
            Text("Date Added : ${item.dateAdded.toString()}"), // Menggunakan dateAdded dari model Product
            const SizedBox(height: 10),
            Text("Description : ${item.description}"),
          ],
        ),
      ),
    );
  }
}
