import 'package:flutter/material.dart';
import 'package:per_rat/models/anime.dart';

class AllAnimeItem extends StatelessWidget {
  const AllAnimeItem({
    super.key,
    required this.anime,
    required this.onSelectAnime,
    required this.onEditScore,
  });

  final Anime anime;
  final void Function(Anime anime) onSelectAnime;
  final void Function(Anime anime) onEditScore;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        minVerticalPadding: 10,
        tileColor: const Color.fromARGB(255, 79, 53, 45),
        contentPadding: const EdgeInsets.all(5),
        title: Text(
          anime.title,
          style: const TextStyle(fontSize: 18),
        ),
        leading: Image.network(
          anime.imageUrl,
        ),
        // Tab(
        //   icon: Image.network(anime.imageUrl),
        //   height: 572,
        // ),
        visualDensity: VisualDensity.comfortable,
        subtitle: Text(
          anime.genre.title,
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
              onEditScore(anime);
            },
            icon: const Icon(Icons.edit_note_sharp)),
        onTap: () {
          onSelectAnime(anime);
        },
      ),
    );
  }
}
