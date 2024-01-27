import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your notifications'),
        centerTitle: true,
      ),
      body: Center(
          child: Text(
        'Notifications Screen',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      )),
    );
  }
}
