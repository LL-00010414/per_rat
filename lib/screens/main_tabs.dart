import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:per_rat/data/firestore_data.dart';
import 'package:per_rat/models/anime.dart';
import 'package:per_rat/screens/discover.dart';
import 'package:per_rat/screens/home.dart';
import 'package:per_rat/screens/my_list.dart';
import 'package:per_rat/screens/notifications_screen.dart';
import 'package:per_rat/screens/seasonal.dart';
import 'package:per_rat/screens/user_profile/user_profile.dart';
import 'package:per_rat/widgets/main_drawer.dart';

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
  //var _isLoading = true;
  //String? _error;

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

    return Scaffold(
      appBar: AppBar(
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
      drawer: MainDrawer(onSelectScreen: _setScreen, user1: user),
      body: currentPage,
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.amber,
        backgroundColor: Theme.of(context).colorScheme.surface,
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
