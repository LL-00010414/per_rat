import 'package:flutter/material.dart';
import 'package:per_rat/data/movie_info.dart';

import 'package:per_rat/models/anime.dart';
import 'package:per_rat/screens/anime_details.dart';
import 'package:per_rat/screens/new_anime.dart';
import 'package:per_rat/widgets/anime_item.dart';
//import 'package:per_rat/widgets/anime_item.dart';
//import 'package:per_rat/widgets/anime_item_trait.dart';
//import 'package:per_rat/data/movie_info.dart';
//import 'package:transparent_image/transparent_image.dart';

class AnimeScreen extends StatefulWidget {
  const AnimeScreen({
    super.key,
    required this.chosenAnime,
  });

  final List<Anime> chosenAnime;

  @override
  State<AnimeScreen> createState() => _AnimeScreenState();
}

class _AnimeScreenState extends State<AnimeScreen> {
  final List<Anime> _registeredAnime = dummyAnime;

  void _addAnime(Anime anime) {
    setState(() {
      _registeredAnime.add(anime);
    });
  }

  void _removeAnime(Anime anime) {
    //final animeName = _registeredAnime.map((anime) => anime.title).toList();
    final animeIndex = _registeredAnime.indexOf(anime);
    setState(() {
      _registeredAnime.remove(anime);
    });
    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: Text("${anime.title} has been deleted"),
        action: SnackBarAction(
            label: "Undo",
            onPressed: () {
              setState(() {
                _registeredAnime.insert(animeIndex, anime);
              });
            }),
      ),
    );
  }

  void _openAddAnimeDialog() {
    showModalBottomSheet(
        context: context, builder: (ctx) => NewAnime(onAddAnime: _addAnime));
  }

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
      itemCount: widget.chosenAnime.length,
      itemBuilder: (ctx, index) => AnimeItem(
        anime: widget.chosenAnime[index],
        onSelectAnime: (anime) {
          selectAnime(context, anime);
        },
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('HOME'),
        actions: [
          IconButton(
            onPressed: _openAddAnimeDialog,
            icon: const Icon(Icons.add_sharp),
          )
        ],
      ),
      body: content,
    );
  }
}
