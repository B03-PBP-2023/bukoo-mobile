import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'book_collection/screens/home_page.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) {
        CookieRequest request = CookieRequest();
        return request;
      },
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
        routes: {HomePage.routeName: (context) => HomePage()},
      ),
    );
  }
}
