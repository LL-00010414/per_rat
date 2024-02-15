import 'package:flutter/material.dart';
import 'package:per_rat/models/anime.dart';
import 'package:per_rat/screens/anime_details.dart';
import 'package:per_rat/screens/edit_score_screen.dart';
import 'package:per_rat/widgets/all_anime_item.dart';

class AllAnimeScreen extends StatelessWidget {
  const AllAnimeScreen({
    super.key,
    required this.myAnimeList,
  });

  final List<Anime> myAnimeList;

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

    void editScore(BuildContext context, Anime anime) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => EditScoreScreen(
                anime: anime,
              )));
    }

    Widget content = const Center(
      child: Text(
        '...',
        style: TextStyle(color: Colors.amber),
      ),
    );
    if (myAnimeList.isNotEmpty) {
      content = ListView.builder(
          itemCount: myAnimeList.length,
          itemBuilder: (ctx, index) => AllAnimeItem(
                anime: myAnimeList[index],
                onSelectAnime: (anime) {
                  selectAnime(context, anime);
                },
                onEditScore: (anime) {
                  editScore(context, anime);
                },
              ));
    }

    return Scaffold(
      body: content,
    );
  }
}
