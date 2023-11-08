import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:per_rat/data/demographic_info.dart';
import 'package:per_rat/data/genre_info.dart';
import 'package:per_rat/data/status_info.dart';
import 'package:per_rat/data/studio_info.dart';

import 'package:per_rat/models/anime.dart';

import 'package:per_rat/screens/anime_details.dart';
import 'package:per_rat/screens/new_anime.dart';
import 'package:per_rat/widgets/anime_item.dart';
import 'package:http/http.dart' as http;

//import 'package:per_rat/widgets/anime_item.dart';
//import 'package:per_rat/widgets/anime_item_trait.dart';
//import 'package:per_rat/data/movie_info.dart';
//import 'package:transparent_image/transparent_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    //required this.chosenAnime,
  });

  //final List<Anime> chosenAnime;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Anime> _registeredAnime = [];
  var _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAnime();
  }

  void _addAnime(Anime anime) {
    setState(() {
      _registeredAnime.add(anime);
    });
  }

  void _removeAnime(Anime anime) {
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

  void _loadAnime() async {
    final url = Uri.https(
        'perratauth-default-rtdb.asia-southeast1.firebasedatabase.app',
        'anime-list.json');
    final response = await http.get(url);

    final Map<String, dynamic> listAnime = json.decode(response.body);
    final List<Anime> loadedAnime = [];

    for (final show in listAnime.entries) {
      final genre = genres.entries
          .firstWhere((genItem) => genItem.value.title == show.value['genre'])
          .value;
      final demographic = demographics.entries
          .firstWhere(
              (demItem) => demItem.value.title == show.value['demographics'])
          .value;
      final studio = studios.entries
          .firstWhere(
              (studItem) => studItem.value.title == show.value['studio'])
          .value;
      final status = statuses.entries
          .firstWhere(
              (statItem) => statItem.value.title == show.value['status'])
          .value;
      final DateTime startDate = formatter.parse(show.value['startDate']);
      final DateTime endDate = formatter.parse(show.value['startDate']);
      final String description = show.value['synopsis'].toString();
      final List<String> synopsis = description.split(',');

      //the logic part
      loadedAnime.add(
        Anime(
          id: show.key,
          title: show.value['title'],
          imageUrl: show.value['imageUrl'],
          synopsis: synopsis,
          totalEpisodes: show.value['totalEpisodes'],
          score: show.value['score'].toString(),
          rank: show.value['rank'].toString(),
          popularity: show.value['popularity'].toString(),
          favorites: show.value['favorites'],
          trailerUrl: show.value['trailerUrl'],
          genre: genre,
          demographic: demographic,
          studio: studio,
          status: status,
          startDate: startDate,
          endDate: endDate,
        ),
      );
    }
    setState(() {
      _registeredAnime = loadedAnime;
      _isLoading = false;
    });
  }

  void _addAnimePage() async {
    final newAnime = await Navigator.of(context).push<Anime>(
      MaterialPageRoute(
        builder: (ctx) => NewAnime(onAddAnime: _addAnime),
      ),
    );

    if (newAnime == null) {
      return;
    }

    setState(() {
      _registeredAnime.add(newAnime);
    });
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
    Widget content = const Center(
      child: Text(
        'No shows are present',
        style: TextStyle(color: Colors.white),
      ),
    );

    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (_registeredAnime.isNotEmpty) {
      content = GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.5,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
        ),
        itemCount: _registeredAnime.length,
        itemBuilder: (ctx, index) => AnimeItem(
          anime: _registeredAnime[index],
          onSelectAnime: (anime) {
            selectAnime(context, anime);
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('HOME'),
        actions: [
          IconButton(
            onPressed: _addAnimePage,
            icon: const Icon(Icons.add_sharp),
          )
        ],
      ),
      body: content,
    );
  }
}
