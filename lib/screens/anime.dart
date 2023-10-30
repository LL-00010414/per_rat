import 'package:flutter/material.dart';

import 'package:per_rat/models/anime.dart';
import 'package:per_rat/screens/anime_details.dart';
import 'package:per_rat/widgets/anime_item.dart';
//import 'package:per_rat/widgets/anime_item.dart';
//import 'package:per_rat/widgets/anime_item_trait.dart';
//import 'package:per_rat/data/movie_info.dart';
//import 'package:transparent_image/transparent_image.dart';

class AnimeScreen extends StatelessWidget {
  const AnimeScreen({
    super.key,
    required this.chosenAnime,
  });

  final List<Anime> chosenAnime;
  //final List<Anime> availableList;

  void selectAnime(BuildContext context, Anime anime) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => AnimeDetailsScreen(
          anime: anime,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.5,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
      itemCount: chosenAnime.length,
      itemBuilder: (ctx, index) => AnimeItem(
        anime: chosenAnime[index],
        onSelectAnime: (anime) {
          selectAnime(context, anime);
        },
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('HOME'),
      ),
      body: content,
    );
  }
}
