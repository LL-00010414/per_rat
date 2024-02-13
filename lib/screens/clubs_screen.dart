import 'package:flutter/material.dart';

class ClubsScreen extends StatelessWidget {
  const ClubsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your clubs'),
        centerTitle: true,
      ),
      body: Center(
          child: Text(
        'Clubs Screen',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      )),
    );
  }
}