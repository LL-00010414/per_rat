import 'package:flutter/material.dart';
import 'package:per_rat/presentation/screens/login_screen.dart';
import 'package:per_rat/presentation/screens/register_screen.dart';

class RegisterOrLoginScreen extends StatefulWidget {
  const RegisterOrLoginScreen({super.key});

  @override
  State<RegisterOrLoginScreen> createState() => _RegisterOrLoginScreenState();
}

class _RegisterOrLoginScreenState extends State<RegisterOrLoginScreen> {
  //show login page first
  bool showLoginScreen = true;

  // switching between login and register pages
  void switchPages() {
    setState(() {
      showLoginScreen = !showLoginScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginScreen) {
      return LoginScreen(onTap: switchPages);
    } else {
      return RegisterScreen(
        onTap: switchPages,
      );
    }
  }
}
