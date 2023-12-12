import 'package:bukoo/core/config.dart';
import 'package:bukoo/core/widgets/left_drawer.dart';
import 'package:bukoo/core/widgets/loading_layer.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

import 'package:bukoo/core/screens/login_page.dart';
import 'package:bukoo/core/widgets/secondary_button.dart';
import 'package:bukoo/core/widgets/select_option.dart';
import 'package:bukoo/core/widgets/primary_button.dart';
import 'package:bukoo/core/widgets/custom_text_field.dart';
import 'package:bukoo/core/etc/custom_icon_icons.dart';
import 'package:provider/provider.dart';

enum Roles { author, reader, admin }

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  static const routeName = '/auth/register';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  static const HEIGHT_ON_TOP = 200.0;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _passwordConfirmation = TextEditingController();
  String? _usernameErrorText;
  String? _emailErrorText;
  String? _passwordErrorText;
  String? _passwordConfirmationErrorText;

  Roles? selectedRole;
  int _currentStep = 0;
  bool _isLoading = false;
  CookieRequest? request;

  void _nextStep() {
    if (selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select your role'),
        ),
      );
      return;
    }
    setState(() {
      _currentStep++;
    });
  }

  void _prevStep() {
    setState(() {
      _currentStep--;
    });
  }

  Widget _buildStep() {
    switch (_currentStep) {
      case 0:
        return _buildFirstStep();
      case 1:
        return _buildSecondStep();
      default:
        return const Placeholder();
    }
  }

  @override
  Widget build(BuildContext context) {
    request = context.watch<CookieRequest>();

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
                      child: _buildStep(),
                    ),
                  ),
                ),
              ],
            ),
            LoadingLayer(isLoading: _isLoading)
          ],
        ));
  }

  Widget _buildFirstStep() {
    return Column(
      children: [
        const SizedBox(height: 64.0),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Registration",
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.w600),
            ),
            Text("1/2")
          ],
        ),
        const SizedBox(height: 24.0),
        const Text("Which describes you best?",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500)),
        const SizedBox(height: 16.0),
        SelectOption(
          selectedRole: selectedRole,
          value: Roles.author,
          onChanged: () {
            setState(() {
              selectedRole = Roles.author == selectedRole ? null : Roles.author;
            });
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(CustomIcon.pencil_alt),
              SizedBox(width: 24.0),
              Text('Author'),
            ],
          ),
        ),
        const SizedBox(height: 16.0),
        SelectOption(
          selectedRole: selectedRole,
          value: Roles.reader,
          onChanged: () {
            setState(() {
              selectedRole = Roles.reader == selectedRole ? null : Roles.reader;
            });
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(CustomIcon.book_collection),
              SizedBox(width: 24.0),
              Text('Reader'),
            ],
          ),
        ),
        const SizedBox(height: 16.0),
        SelectOption(
          selectedRole: selectedRole,
          value: Roles.admin,
          onChanged: () {
            setState(() {
              selectedRole = Roles.admin == selectedRole ? null : Roles.admin;
            });
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(CustomIcon.admin_dashboard),
              SizedBox(width: 24.0),
              Text('Admin'),
            ],
          ),
        ),
        const SizedBox(height: 48.0),
        PrimaryButton(onPressed: _nextStep, child: const Text('Next')),
        const SizedBox(height: 24.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Already have account?',
                style: TextStyle(fontSize: 14.0)),
            TextButton(
              child: Text('Login',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  )),
              onPressed: () {
                Navigator.pushReplacementNamed(context, LoginPage.routeName);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSecondStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 64.0),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Registration",
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.w600),
            ),
            Text("2/2")
          ],
        ),
        const SizedBox(height: 24.0),
        CustomTextField(
          controller: _username,
          labelText: "Username",
          prefixIcon: const Icon(CustomIcon.profile),
          hintText: "yourusername",
          errorText: _usernameErrorText,
        ),
        const SizedBox(height: 24.0),
        CustomTextField(
          controller: _email,
          labelText: "Email",
          prefixIcon: const Icon(Icons.email),
          hintText: "bukoo@example.com",
          errorText: _emailErrorText,
        ),
        const SizedBox(height: 24.0),
        CustomTextField(
          controller: _password,
          labelText: "Password",
          obscureText: true,
          hintText: "********",
          errorText: _passwordErrorText,
        ),
        const SizedBox(height: 24.0),
        CustomTextField(
          controller: _passwordConfirmation,
          labelText: "Confirm Password",
          obscureText: true,
          hintText: "********",
          errorText: _passwordConfirmationErrorText,
        ),
        const SizedBox(height: 24.0),
        PrimaryButton(onPressed: _onSubmit, child: const Text('Submit')),
        const SizedBox(height: 24.0),
        SecondaryButton(onPressed: _prevStep, child: const Text('Back')),
        const SizedBox(height: 24.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Don\'t have account yet?',
                style: TextStyle(fontSize: 14.0)),
            TextButton(
              child: Text('Login',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  )),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }

  void _onSubmit() async {
    _resetErrorText();
    setState(() {
      _isLoading = true;
    });

    if (_formKey.currentState!.validate()) {
      final formData = {
        'username': _username.text,
        'email': _email.text,
        'password1': _password.text,
        'password2': _passwordConfirmation.text,
        'is_author': selectedRole == Roles.author ? 'true' : 'false',
        'is_admin': selectedRole == Roles.admin ? 'true' : 'false',
      };

      final response =
          await request!.post('$BASE_URL/auth/register/', formData);
      if (response['status'] == 'success') {
        Navigator.pushReplacementNamed(context, LoginPage.routeName);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration success!'),
          ),
        );
      } else {
        final message = response['message'];
        if (message.containsKey('username')) {
          setState(() {
            _usernameErrorText = message['username'][0];
          });
        }
        if (message.containsKey('email')) {
          setState(() {
            _emailErrorText = message['email'][0];
          });
        }
        if (message.containsKey('password1')) {
          setState(() {
            _passwordErrorText = message['password1'][0];
          });
        }
        if (message.containsKey('password2')) {
          setState(() {
            _passwordConfirmationErrorText = message['password2'][0];
          });
        }
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _resetErrorText() {
    setState(() {
      _usernameErrorText = null;
      _emailErrorText = null;
      _passwordErrorText = null;
      _passwordConfirmationErrorText = null;
    });
  }
}