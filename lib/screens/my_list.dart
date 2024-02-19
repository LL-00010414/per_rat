import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:per_rat/data/demographic_info.dart';
import 'package:per_rat/data/genre_info.dart';
//import 'package:per_rat/data/movie_info.dart';
import 'package:per_rat/data/status_info.dart';
import 'package:per_rat/data/studio_info.dart';
import 'package:per_rat/models/anime.dart';
import 'package:per_rat/screens/all_anime_screen.dart';
import 'package:http/http.dart' as http;

class MyListScreen extends StatefulWidget {
  const MyListScreen({
    super.key,
  });

  //final List<Anime> lastAnime;

  @override
  State<MyListScreen> createState() => _MyListScreenState();
}

class _MyListScreenState extends State<MyListScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  List<Anime> _registeredAnime = [];
  var _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _loadAnime();
  }

  void _loadAnime() async {
    final url = Uri.https(
        'perratauth-default-rtdb.asia-southeast1.firebasedatabase.app',
        'movie-list.json');
    final response = await http.get(url);

    if (response.statusCode >= 400) {
      setState(() {
        _error = 'Failed to load data. Please try again later!';
      });
    }

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
      //final animeSeasonIn = formatterMY.format(startDate);
    }
    setState(() {
      _registeredAnime = loadedAnime;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: TabBar(
          isScrollable: true,
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
              text: 'All',
            ),
            Tab(
              text: 'Watching',
            ),
            Tab(
              text: 'Completed',
            ),
            Tab(
              text: 'On Hold',
            ),
            Tab(
              text: 'Dropped',
            ),
            Tab(
              text: 'Plan to Watch',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          AllAnimeScreen(myAnimeList: _registeredAnime),
          const Center(
            child: Text(
              'Watching',
              style: TextStyle(color: Colors.amber),
            ),
          ),
          const Center(
            child: Text(
              'Completed',
              style: TextStyle(color: Colors.amber),
            ),
          ),
          const Center(
            child: Text(
              'On Hold',
              style: TextStyle(color: Colors.amber),
            ),
          ),
          const Center(
            child: Text(
              'Dropped',
              style: TextStyle(color: Colors.amber),
            ),
          ),
          const Center(
            child: Text(
              'Plan to Watch',
              style: TextStyle(color: Colors.amber),
            ),
          ),
        ],
      ),
    );
  }
}
