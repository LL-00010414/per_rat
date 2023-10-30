import 'package:flutter/material.dart';
import 'package:per_rat/data/movie_info.dart';
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

  final Anime chosenAnime;

  void selectAnime(BuildContext context, Anime chosenAnime) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => AnimeDetailsScreen(
              anime: chosenAnime,
            )));
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
      itemCount: dummyAnime.length,
      itemBuilder: (ctx, index) => AnimeItem(
          anime: dummyAnime[index],
          onSelectAnime: (anime) {
            selectAnime(context, chosenAnime);
          }),
    );

    // Center(
    //   child: Column(
    //     mainAxisSize: MainAxisSize.min,
    //     children: [
    //       Text(
    //         'Uh oh ... nothing here!',
    //         style: Theme.of(context).textTheme.headlineLarge!.copyWith(
    //               color: Theme.of(context).colorScheme.onBackground,
    //             ),
    //       ),
    //       const SizedBox(height: 16),
    //       Text(
    //         'Try selecting a different anime!',
    //         style: Theme.of(context).textTheme.bodyLarge!.copyWith(
    //               color: Theme.of(context).colorScheme.onBackground,
    //             ),
    //       ),
    //     ],
    //   ),
    // );

    return Scaffold(
      appBar: AppBar(
        title: const Text('HOME'),
      ),
      body: content,
    );
  }
}
