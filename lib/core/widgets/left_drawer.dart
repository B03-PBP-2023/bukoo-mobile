import 'package:bukoo/book_collection/screens/home_page.dart';
import 'package:flutter/material.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
              child: Column(
            children: [Text('Bukoo Logo')],
          )),
          ListTile(
            leading: const Icon(Icons.book_outlined),
            title: const Text('Book Collection'),
            onTap: () => {Navigator.pushNamed(context, HomePage.routeName)},
          ),
          ListTile(
            leading: const Icon(Icons.person_2_outlined),
            title: const Text('Profile'),
            onTap: () => {
              // TODO: Navigate to profile
            },
          ),
          ListTile(
            leading: const Icon(Icons.reviews_outlined),
            title: const Text('Review'),
            onTap: () => {
              // TODO: Navigate to review
            },
          ),
          ListTile(
            leading: const Icon(Icons.forum_outlined),
            title: const Text('Discussion Forum'),
            onTap: () => {
              // TODO: Navigate to discussion forum
            },
          ),
          ListTile(
            leading: const Icon(Icons.admin_panel_settings_outlined),
            title: const Text('Admin Dashboard'),
            onTap: () => {
              // TODO: Navigate to admin dashboard
            },
          ),
        ],
      ),
    );
  }
}
