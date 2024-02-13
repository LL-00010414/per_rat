import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your notifications'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.mark_chat_unread_outlined),
          )
        ],
      ),
      body: Center(
          child: Text(
        'No notifications present!',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      )),
    );
  }
}
