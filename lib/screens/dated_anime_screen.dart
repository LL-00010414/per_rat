import 'package:flutter/material.dart';
import 'package:per_rat/models/anime.dart';
import 'package:per_rat/screens/anime_details.dart';
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
    void selectAnime(BuildContext context, Anime anime) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => AnimeDetailsScreen(
            anime: anime,
          ),
        ),
      );
    }

    Widget content = const Center(
      child: Text(
        'No anime present for this date!',
        style: TextStyle(color: Colors.amber),
      ),
    );
    if (datedAnime.isNotEmpty) {
      content = ListView.builder(
          itemCount: datedAnime.length,
          itemBuilder: (ctx, index) => DatedAnimeItem(
                anime: datedAnime[index],
                onSelectAnime: (anime) {
                  selectAnime(context, anime);
                },
              ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(animeYM),
      ),
      body: content,
    );
  }
}
