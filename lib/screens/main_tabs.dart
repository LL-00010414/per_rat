import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:per_rat/data/demographic_info.dart';
import 'package:per_rat/data/genre_info.dart';

import 'package:per_rat/data/status_info.dart';
import 'package:per_rat/data/studio_info.dart';
import 'package:per_rat/models/anime.dart';

import 'package:per_rat/screens/discover.dart';
import 'package:per_rat/screens/home.dart';
import 'package:per_rat/screens/my_list.dart';
import 'package:per_rat/screens/notifications_screen.dart';
import 'package:per_rat/screens/user_profile/profile_screen.dart';

import 'package:per_rat/screens/seasonal.dart';
import 'package:per_rat/widgets/main_drawer.dart';
import 'package:http/http.dart' as http;

class MainTabsScreen extends StatefulWidget {
  const MainTabsScreen({
    super.key,
  });

  // void _selectAnime(BuildContext context, Item item) {
  //   final filteredAnime =
  //       availableList.where((anime) => anime.id.contains(item.id)).toList();

  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (ctx) => AnimeScreen(
  //         chosenAnime: filteredAnime,
  //       ),
  //     ),
  //   );
  // }

  @override
  State<MainTabsScreen> createState() {
    return _MainTabsScreenState();
  }
}

class _MainTabsScreenState extends State<MainTabsScreen> {
  int _selectedPageIndex = 0;
  List<Anime> _registeredAnime = [];
  //var _isLoading = true;
  //String? _error;

  @override
  void initState() {
    super.initState();
    _loadAnime();
  }

  void _loadAnime() async {
    final url = Uri.https(
        'perratauth-default-rtdb.asia-southeast1.firebasedatabase.app',
        'movie-list.json');
    final response = await http.get(url);

    if (response.statusCode >= 400) {
      setState(() {
        'Failed to load data. Please try again later!';
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
      //_isLoading = false;
    });
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => const ProfileScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final ongoingAnime1 = _registeredAnime
        .where((anime) => anime.status.title.contains('Ongoing'))
        .toList();
    final trendingAnime1 = _registeredAnime
        .where((anime1) => int.parse(anime1.popularity) < 1000)
        .toList();
    final upcomingAnime1 = _registeredAnime
        .where((anime3) => anime3.status.title.contains('Upcoming'))
        .toList();

    final user = FirebaseAuth.instance.currentUser!;

    Widget currentPage = const HomeScreen();

    if (_selectedPageIndex == 1) {
      currentPage = DiscoverScreen(
        ongoingAnime: ongoingAnime1,
        trendingAnime: trendingAnime1,
        upcomingAnime: upcomingAnime1,
      );
    }
    if (_selectedPageIndex == 2) {
      currentPage = const SeasonalScreen();
    }
    if (_selectedPageIndex == 3) {
      currentPage = const MyListScreen();
    }

    // void signUserOut() {
    //   GoogleSignIn().signOut();
    //   FirebaseAuth.instance.signOut();
    // }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'PERRAT',
          // style: TextStyle(color: Colors.amberAccent),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => NotificationsScreen()));
              },
              icon: const Icon(
                Icons.notifications_outlined,
                size: 30,
              ))
        ],
      ),
      drawer: MainDrawer(onSelectScreen: _setScreen, user1: user),
      body: currentPage,
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.amber,
        backgroundColor: Theme.of(context).colorScheme.background,
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            tooltip: 'Home page',
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            tooltip: 'Search anime',
            icon: Icon(Icons.search_rounded),
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            tooltip: 'Seasonal anime',
            icon: Icon(Icons.calendar_today_rounded),
            label: 'Seasonal',
          ),
          BottomNavigationBarItem(
            tooltip: 'Your anime list',
            icon: Icon(Icons.list_rounded),
            label: 'MyList',
          ),
        ],
      ),
    );
  }
}
