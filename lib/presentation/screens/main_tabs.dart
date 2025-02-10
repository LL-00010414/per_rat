import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:per_rat/data/repositories/firestore_data.dart';
import 'package:per_rat/presentation/drawer_screens/new_drawer.dart';
import 'package:per_rat/presentation/drawer_screens/notifications_screen.dart';
import 'package:per_rat/data/models/anime.dart';
import 'package:per_rat/presentation/screens/discover.dart';
import 'package:per_rat/presentation/screens/home.dart';
import 'package:per_rat/presentation/screens/my_list.dart';
import 'package:per_rat/presentation/screens/seasonal.dart';
import 'package:per_rat/presentation/user_profile_screens/profile.dart';

class MainTabsScreen extends StatefulWidget {
  const MainTabsScreen({
    super.key,
  });

  @override
  State<MainTabsScreen> createState() {
    return _MainTabsScreenState();
  }
}

class _MainTabsScreenState extends State<MainTabsScreen> {
  int _selectedPageIndex = 0;
  List<Anime> _registeredAnime = [];
  //final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
    _fetchAnime();
  }

  void _fetchAnime() async {
    List<Anime> loadedAnime = await loadAnimeFromFirestore();
    setState(() {
      _registeredAnime = loadedAnime;
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
    final ongoingAnime = _registeredAnime
        .where((anime) =>
            anime.startDate.isAtSameMomentAs(DateTime.now()) ||
            anime.startDate.isBefore(DateTime.now()) && anime.endDate.year == 0)
        .toList();

    final trendingAnime1 = _registeredAnime
        .where((anime1) => int.parse(anime1.popularity) < 1000)
        .toList();

    final upcomingAnime = _registeredAnime
        .where((anime) =>
            anime.startDate.isAfter(DateTime.now()) &&
                anime.endDate.year == 0 ||
            anime.startDate.year == 0)
        .toList();

    final user = FirebaseAuth.instance.currentUser!;

    Widget currentPage = const HomeScreen();

    if (_selectedPageIndex == 1) {
      currentPage = DiscoverScreen(
        ongoingAnime: ongoingAnime,
        trendingAnime: trendingAnime1,
        upcomingAnime: upcomingAnime,
      );
    }
    if (_selectedPageIndex == 2) {
      currentPage = const SeasonalScreen();
    }
    if (_selectedPageIndex == 3) {
      currentPage = const MyListScreen();
    }

    return Scaffold(
      //backgroundColor: Colors.black,
      appBar: AppBar(
        //backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          'PERRAT',
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
              )),
        ],
      ),
      drawer: NewDrawer(onSelectScreen: _setScreen, user1: user),
      //MainDrawer(onSelectScreen: _setScreen, user1: user),
      body: currentPage,
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.amber,
        backgroundColor: Theme.of(context).colorScheme.surface,

        //Theme.of(context).colorScheme.surface,
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
