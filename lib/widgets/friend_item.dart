import 'package:flutter/material.dart';

class FriendItem extends StatelessWidget {
  const FriendItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        minVerticalPadding: 10,
        tileColor: const Color.fromARGB(255, 79, 53, 45),
        contentPadding: const EdgeInsets.all(5),
        title: const Text(
          'Jack',
          style: TextStyle(fontSize: 18),
        ),
        leading: Image.network(
          'https://creazilla-store.fra1.digitaloceanspaces.com/icons/7915246/male-icon-md.png',
        ),
        // Tab(
        //   icon: Image.network(anime.imageUrl),
        //   height: 572,
        // ),
        visualDensity: VisualDensity.comfortable,
        subtitle: const Text(
          'online',
          style: TextStyle(color: Color.fromARGB(248, 33, 214, 87)),
        ),
        isThreeLine: true,
      ),
    );
  }
}
