import 'package:flutter/material.dart';
import 'package:per_rat/data/models/anime.dart';

class ArchiveAnimeItem extends StatelessWidget {
  const ArchiveAnimeItem({
    super.key,
    required this.onPickSeason,
    required this.datedAnime,
    required this.animeSeason,
  });

  final List<Anime> datedAnime;
  final void Function(List<Anime> datedAnime) onPickSeason;
  final String animeSeason;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        onPickSeason(datedAnime);
      },
      child: Text(animeSeason),
    );
  }
}
