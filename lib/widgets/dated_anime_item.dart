import 'package:flutter/material.dart';
import 'package:per_rat/models/anime.dart';

class DatedAnimeItem extends StatelessWidget {
  const DatedAnimeItem({
    super.key,
    required this.anime,
    required this.onSelectAnime,
  });

  final Anime anime;
  final void Function(Anime anime) onSelectAnime;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(anime.title),
        leading: Tab(
          icon: Image.network(anime.imageUrl),
          height: 50,
        ),
        trailing: Text(anime.totalEpisodes.toString()),
        onTap: () {
          onSelectAnime(anime);
        },
      ),
    );
  }
}
