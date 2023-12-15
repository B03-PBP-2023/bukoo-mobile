import 'package:bukoo/book_collection/screens/book_submission_page.dart';
import 'package:bukoo/book_collection/screens/home_page.dart';
import 'package:bukoo/core/config.dart';
import 'package:bukoo/core/models/user.dart';
import 'package:bukoo/core/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:bukoo/admin_dashboard/admin_dash.dart';
import 'package:bukoo/core/etc/custom_icon_icons.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final user = context.watch<User>();

    void _onLogout() async {
      {
        try {
          await request.logout("$BASE_URL/auth/logout/");
        } catch (e) {
          request.loggedIn = false;
        } finally {
          user.resetUser();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Logout successful!'),
            ),
          );
          Navigator.pushNamed(context, LoginPage.routeName);
        }
      }
    }

    return Drawer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Column(
          children: [
            const Column(
              children: [
                Image(
                  image: AssetImage('assets/logo.png'),
                  width: 160,
                  fit: BoxFit.cover,
                ),
                Text(
                  "Read More, Discover More, Be More.",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 48.0),
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: ListTile(
                leading: const Icon(Icons.home_outlined),
                title: const Text('Home'),
                onTap: () => {Navigator.pushNamed(context, HomePage.routeName)},
              ),
            ),
            Visibility(
              visible: request.loggedIn,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: ListTile(
                  leading: const Icon(CustomIcon.profile),
                  title: const Text('Profile'),
                  onTap: () => {},
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: ListTile(
                leading: const Icon(CustomIcon.discussion),
                title: const Text('Discussion Forum'),
                onTap: () =>
                    {Navigator.pushNamed(context, AdminDash.routeName)},
              ),
            ),
            Visibility(
              visible: request.loggedIn &&
                  (user.isAdmin == null ? false : user.isAdmin!),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: ListTile(
                    leading: const Icon(CustomIcon.admin_dashboard),
                    title: const Text('Admin Dashboard'),
                    onTap: () =>
                        Navigator.pushNamed(context, '/admin-dashboard')),
              ),
            ),
            Visibility(
              visible: request.loggedIn,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Logout'),
                    onTap: _onLogout),
              ),
            ),
            Visibility(
              visible: !request.loggedIn,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: ListTile(
                    leading: const Icon(Icons.login),
                    title: const Text('Login'),
                    onTap: () =>
                        {Navigator.pushNamed(context, LoginPage.routeName)}),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
