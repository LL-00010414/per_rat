import 'package:flutter/material.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        centerTitle: true,
      ),
      body: Center(
          child: Text(
        'Messages Screen',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      )),
    );
  }
}
