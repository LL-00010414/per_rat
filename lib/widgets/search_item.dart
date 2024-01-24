import 'package:flutter/material.dart';
import 'package:per_rat/models/anime.dart';

class SearchItem extends StatelessWidget {
  const SearchItem({
    super.key,
    required this.anime,
    required this.onPickAnime,
    required this.result1,
  });

  final Anime anime;
  final void Function(Anime anime) onPickAnime;
  final String result1;

  // final List<Anime> searchResult =
  //   dummyAnime.where((a) => a.title.contains(result)).toList();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        child: Text('ア'),
      ),
      textColor: Colors.amberAccent,
      title: Text(result1),
      onTap: () {
        onPickAnime(anime);
      },
    );
  }
}
