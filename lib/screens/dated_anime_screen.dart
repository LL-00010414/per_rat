import 'package:flutter/material.dart';
import 'package:per_rat/models/anime.dart';
import 'package:per_rat/widgets/dated_anime_item.dart';

class DatedAnimeScreen extends StatelessWidget {
  const DatedAnimeScreen({
    super.key,
    required this.datedAnime,
    required this.animeYM,
  });
  final List<Anime> datedAnime;
  final String animeYM;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(animeYM),
      ),
      body: ListView.builder(
          itemCount: datedAnime.length,
          itemBuilder: (ctx, index) => DatedAnimeItem(
                anime: datedAnime[index],
                onSelectAnime: (anime) {},
              )),
    );
  }
}
