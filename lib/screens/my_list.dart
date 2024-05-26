import 'package:flutter/material.dart';

//import 'package:per_rat/data/movie_info.dart';

import 'package:per_rat/screens/all_anime_screen.dart';
//import 'package:http/http.dart' as http;
import 'package:per_rat/screens/generic_rating_screen.dart';

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
  //List<Anime> _registeredAnime = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
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
          AllAnimeScreen(),
          GenericAnimeScreen(filterStatus: 'Watching'),
          GenericAnimeScreen(filterStatus: 'Completed'),
          GenericAnimeScreen(filterStatus: 'On Hold'),
          GenericAnimeScreen(filterStatus: 'Dropped'),
          GenericAnimeScreen(filterStatus: 'Plan to Watch'),
        ],
      ),
    );
  }
}
