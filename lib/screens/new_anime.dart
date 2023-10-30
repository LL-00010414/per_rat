import 'package:flutter/material.dart';
import 'package:per_rat/models/anime.dart';

class NewAnime extends StatefulWidget {
  const NewAnime({
    super.key,
    required this.onAddAnime,
  });

  final void Function(Anime anime) onAddAnime;

  @override
  State<NewAnime> createState() => _NewAnimeState();
}

class _NewAnimeState extends State<NewAnime> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
