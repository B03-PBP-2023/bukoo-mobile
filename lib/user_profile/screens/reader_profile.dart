import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bukoo/core/widgets/left_drawer.dart';
import 'package:bukoo/user_profile/models/ReaderData.dart';

class ReaderProfile extends StatefulWidget {
  const ReaderProfile({super.key});

  static const routeName = '/profile';

  @override
  State<ReaderProfile> createState() => ReaderProfilePage();
}

class ReaderProfilePage extends State<ReaderProfile> {
  Future<ReaderData> fetchReaderProfile() async {
    final response = await http.get(Uri.parse('https://bukoo.azurewebsites.net/profile/json/'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ReaderData.fromJson(data);
    } else {
      throw Exception('Failed to load user profile data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile',
            style: TextStyle(fontWeight: FontWeight.bold)
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder<ReaderData>(
        future: fetchReaderProfile(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final readerData = snapshot.data!;
            return Column(
              children: [
                Image.network(readerData.profilePictureUrl),
                Text('Name: ${readerData.name}'),
                Text('Gender: ${readerData.gender}'),
                Text('Date of Birth: ${readerData.dateOfBirth}'),
                Text('About: ${readerData.about}'),
                Text('Preferred Genre: ${readerData.preferredGenre}'),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}