import 'package:flutter/material.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings'),
        centerTitle: true,
      ),
      body: Center(
          child: Text(
        'Account Settings Screen',
        style: TextStyle(
          color: Colors.amber,
        ),
      )),
    );
  }
}
