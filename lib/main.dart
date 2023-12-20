// ignore_for_file: use_build_context_synchronously

import 'package:bukoo/book_collection/screens/book_submission_page.dart';
import 'package:bukoo/book_collection/screens/search_page.dart';
import 'package:bukoo/core/models/user.dart';
import 'package:bukoo/core/screens/login_page.dart';
import 'package:bukoo/core/screens/register_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'book_collection/screens/home_page.dart';
import 'package:bukoo/admin_dashboard/admin_dash.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<CookieRequest>(
          create: (_) {
            CookieRequest request = CookieRequest();
            return request;
          },
        ),
        FutureProvider<User>(
          create: (_) async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            final request = _.watch<CookieRequest>();
            String? userJson = prefs.getString('user');
            if (userJson != null) {
              User user = User.fromJson(jsonDecode(userJson));
              return user;
            }
            return User();
          },
          initialData: User(),
        ),
      ],
      child: MaterialApp(
        title: "Bukoo",
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFFADC4CE),
              primary: const Color(0xFFADC4CE),
              secondary: const Color(0xFF354259)),
          useMaterial3: true,
        ),
        initialRoute: HomePage.routeName,
        routes: {
          HomePage.routeName: (context) => HomePage(),
          LoginPage.routeName: (context) => LoginPage(),
          RegisterPage.routeName: (context) => RegisterPage(),
          AdminDash.routeName: (context) => AdminDash(),
          BookSubmissionPage.routeName: (context) => BookSubmissionPage(),
          SearchPage.routeName: (context) => SearchPage(),
        },
      ),
    );
  }
}
