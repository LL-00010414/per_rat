import 'package:flutter/material.dart';
import 'package:per_rat/models/show_rating.dart';

class AllAnimeItem extends StatelessWidget {
  const AllAnimeItem({
    super.key,
    required this.showRating,
    required this.onSelectRating,
    required this.onEditRating,
  });

  final ShowRating showRating;

  final void Function(ShowRating showRating) onSelectRating;
  final void Function(ShowRating showRating) onEditRating;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        minVerticalPadding: 10,
        tileColor: const Color.fromARGB(255, 79, 53, 45),
        contentPadding: const EdgeInsets.all(5),
        title: Text(
          showRating.showName,
          style: const TextStyle(fontSize: 18),
        ),
        leading: Text(showRating.score),
        // Tab(
        //   icon: Image.network(anime.imageUrl),
        //   height: 572,
        // ),
        visualDensity: VisualDensity.comfortable,
        subtitle: Text(
          showRating.progress,
          style: const TextStyle(color: Color.fromARGB(248, 214, 99, 33)),
        ),
        isThreeLine: true,
        trailing: IconButton.outlined(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            onPressed: () {
              onEditRating(showRating);
            },
            icon: const Icon(Icons.edit_note_sharp)),
        onTap: () {
          onSelectRating(showRating);
        },
      ),
    );
  }
}
