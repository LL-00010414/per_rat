import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:per_rat/screens/main_tabs.dart';
import 'package:per_rat/screens/register_or_login.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //user logged in
          if (snapshot.hasData) {
            return const MainTabsScreen();
          }

          // user not logged in
          else {
            return const RegisterOrLoginScreen();
          }
        },
      ),
    );
  }
}
