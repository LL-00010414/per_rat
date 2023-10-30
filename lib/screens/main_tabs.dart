import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:per_rat/data/movie_info.dart';

import 'package:per_rat/screens/discover.dart';
import 'package:per_rat/screens/anime.dart';
import 'package:per_rat/screens/my_list.dart';
import 'package:per_rat/screens/profile_screen.dart';

import 'package:per_rat/screens/seasonal.dart';
import 'package:per_rat/widgets/main_drawer.dart';

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
    final ongoingAnime1 =
        dummyAnime.where((anime) => anime.status.contains('Ongoing')).toList();
    final trendingAnime1 = dummyAnime
        .where((anime1) => int.parse(anime1.popularity) < 1000)
        .toList();
    final upcomingAnime1 = dummyAnime
        .where((anime3) => anime3.status.contains('Upcoming'))
        .toList();

    final user = FirebaseAuth.instance.currentUser!;

    Widget currentPage = AnimeScreen(
      chosenAnime: dummyAnime,
    );

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

    void signUserOut() {
      GoogleSignIn().signOut();
      FirebaseAuth.instance.signOut();
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Welcome ${user.email!.substring(0, 11)}',
        ),
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      drawer: MainDrawer(onSelectScreen: _setScreen, user1: user),
      body: currentPage,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        //backgroundColor: Theme.of(context).colorScheme.onSecondary,
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
