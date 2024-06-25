import 'package:flutter/material.dart';
import 'package:per_rat/widgets/friend_item.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Widget content = ListView.builder(
        itemCount: 5, itemBuilder: (ctx, index) => const FriendItem());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Friends'),
      ),
      body: content,
    );
  }
}
