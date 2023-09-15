import 'dart:js_interop';

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
    required this.anime,
    required this.title,
  });

  final String? title;
  final Anime anime;

  void selectAnime(BuildContext context, Anime anime) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => AnimeDetailsScreen(
              anime: anime,
            )));
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Uh oh ... nothing here!',
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            'Try selecting a different anime!',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
        ],
      ),
    );

    if (anime.isNull) {
      content = GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.5,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
        ),
        itemBuilder: (ctx, index) => AnimeItem(
            anime: anime,
            onSelectAnime: (anime) {
              selectAnime(context, anime);
            }),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title!),
      ),
      body: content,
    );
  }
}
