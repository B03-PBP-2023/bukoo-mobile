import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bukoo/book_collection/screens/home_page.dart';
import 'package:bukoo/core/config.dart';
import 'package:bukoo/core/models/user.dart';
import 'package:bukoo/core/screens/register_page.dart';
import 'package:bukoo/core/widgets/left_drawer.dart';
import 'package:bukoo/core/widgets/loading_layer.dart';
import 'package:bukoo/core/widgets/custom_text_field.dart';
import 'package:bukoo/core/widgets/primary_button.dart';
import 'package:bukoo/core/etc/custom_icon_icons.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static const routeName = '/auth/login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _isLoading = false;
  String? _errorText;

  static const HEIGHT_ON_TOP = 200.0;

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    void _onLogin() async {
      setState(() {
        _errorText = null;
        _isLoading = true;
      });

      if (_formKey.currentState!.validate()) {
        final response = await request.login("$BASE_URL/auth/login/", {
          "username": _username.text,
          "password": _password.text,
        });
        if (response['status'] == 'success') {
          // Set user (immutable)
          context.read<User>().setUser(response['data']);

          // Store user data in shared preferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String userJson = jsonEncode(response['data']);
          await prefs.setString('user', userJson);

          Navigator.pushReplacementNamed(context, HomePage.routeName);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login success!'),
            ),
          );
        } else {
          setState(() {
            _errorText = response['message'];
          });
        }
      }
      setState(() {
        _isLoading = false;
      });
    }

    return Scaffold(
        appBar: AppBar(),
        drawer: const LeftDrawer(),
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context).colorScheme.primary,
            ),
            ListView(
              children: [
                const SizedBox(
                  height: HEIGHT_ON_TOP,
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(64.0),
                    ),
                  ),
                  constraints: BoxConstraints(
                    minHeight:
                        MediaQuery.of(context).size.height - HEIGHT_ON_TOP,
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 60.0, vertical: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 64.0),
                          const Text(
                            "Hi!",
                            style: TextStyle(
                                fontSize: 36, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 24.0),
                          CustomTextField(
                            controller: _username,
                            labelText: "Username",
                            prefixIcon: const Icon(CustomIcon.profile),
                            hintText: "yourusername",
                            errorText: _errorText,
                          ),
                          const SizedBox(height: 24.0),
                          CustomTextField(
                            controller: _password,
                            labelText: "Password",
                            obscureText: true,
                            hintText: "********",
                          ),
                          const SizedBox(height: 24.0),
                          PrimaryButton(
                              onPressed: _onLogin, child: const Text('Login')),
                          const SizedBox(height: 24.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Don\'t have account yet?',
                                  style: TextStyle(fontSize: 14.0)),
                              TextButton(
                                child: Text('Register',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                    )),
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, RegisterPage.routeName);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            LoadingLayer(isLoading: _isLoading)
          ],
        ));
  }
}
