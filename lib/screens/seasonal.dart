import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:per_rat/data/demographic_info.dart';
import 'package:per_rat/data/genre_info.dart';

import 'package:per_rat/data/status_info.dart';
import 'package:per_rat/data/studio_info.dart';
import 'package:per_rat/models/anime.dart';
import 'package:per_rat/screens/anime_details.dart';
import 'package:per_rat/widgets/seasonal_anime_item.dart';
import 'package:http/http.dart' as http;

class SeasonalScreen extends StatefulWidget {
  const SeasonalScreen({
    super.key,
  });

  //final List<Anime> lastAnime;

  @override
  State<SeasonalScreen> createState() => _SeasonalScreenState();
}

class _SeasonalScreenState extends State<SeasonalScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  List<Anime> _registeredAnime = [];
  var _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadAnime();
  }

  void _loadAnime() async {
    final url = Uri.https(
        'perratauth-default-rtdb.asia-southeast1.firebasedatabase.app',
        'anime-list.json');
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
    }
    setState(() {
      _registeredAnime = loadedAnime;
      _isLoading = false;
    });
  }

  void pickAnime(BuildContext context, Anime anime) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => AnimeDetailsScreen(
          anime: anime,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Anime> lastAnime = _registeredAnime
        .where((anime) => anime.status.title.contains('Completed'))
        .toList();
    final List<Anime> thisSeaAnime = _registeredAnime
        .where((anime1) => anime1.status.title.contains('Ongoing'))
        .toList();
    final List<Anime> nextAnime = _registeredAnime
        .where((anime1) => anime1.status.title.contains('Upcoming'))
        .toList();

    //Last season tab
    Widget lastContent = const Center(
      child: Text(
        'No shows are present',
        style: TextStyle(color: Colors.amber),
      ),
    );
    if (_isLoading) {
      lastContent = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (lastAnime.isNotEmpty) {
      lastContent = GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.5,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
        ),
        itemCount: lastAnime.length,
        itemBuilder: (ctx, index) => SeasonalAnimeItem(
          anime: lastAnime[index],
          onPickAnime: (anime) {
            pickAnime(context, anime);
          },
        ),
      );
    }

    //This season tab
    Widget thisSeaContent = const Center(
      child: Text(
        'No shows are present',
        style: TextStyle(color: Colors.amber),
      ),
    );
    if (_isLoading) {
      thisSeaContent = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (thisSeaAnime.isNotEmpty) {
      thisSeaContent = GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.5,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
        ),
        itemCount: thisSeaAnime.length,
        itemBuilder: (ctx, index) => SeasonalAnimeItem(
          anime: thisSeaAnime[index],
          onPickAnime: (anime) {
            pickAnime(context, anime);
          },
        ),
      );
    }

    //Next season tab
    Widget nextContent = const Center(
      child: Text(
        'No shows are present',
        style: TextStyle(color: Colors.amber),
      ),
    );
    if (_isLoading) {
      nextContent = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (nextAnime.isNotEmpty) {
      nextContent = GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.5,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
        ),
        itemCount: nextAnime.length,
        itemBuilder: (ctx, index) => SeasonalAnimeItem(
          anime: nextAnime[index],
          onPickAnime: (anime) {
            pickAnime(context, anime);
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: TabBar(
          // indicatorWeight: 2,
          // //padding: const EdgeInsets.all(0),
          // //labelPadding: const EdgeInsets.all(0),
          // labelStyle: const TextStyle(
          //   fontSize: 12,
          // )
          // fontWeight: FontWeight.normal,
          // fontStyle: FontStyle.normal,
          // ,
          isScrollable: false,
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
              text: 'Last',
            ),
            Tab(
              text: 'This season',
            ),
            Tab(
              text: 'Next',
            ),
            Tab(
              text: 'Archive',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          Center(
            child: lastContent,
          ),
          Center(
            child: thisSeaContent,
          ),
          Center(
            child: nextContent,
          ),
          const Center(
            child: Text(
              'Archive',
              style: TextStyle(color: Colors.amber),
            ),
          ),
        ],
      ),
    );
  }
}
