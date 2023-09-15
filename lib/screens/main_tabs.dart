import 'package:flutter/material.dart';
import 'package:per_rat/models/anime.dart';
import 'package:per_rat/screens/discover.dart';
import 'package:per_rat/screens/anime.dart';
import 'package:per_rat/screens/my_list.dart';
import 'package:per_rat/screens/seasonal.dart';
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

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Anime availableAnime;

    Widget currentPage = AnimeScreen(
      anime: availableAnime,
      title: availableAnime.title,
    );

    if (_selectedPageIndex == 1) {
      currentPage = const DiscoverScreen();
    }
    if (_selectedPageIndex == 2) {
      currentPage = const SeasonalScreen();
    }
    if (_selectedPageIndex == 3) {
      currentPage = const MyListScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('PerRat'),
      ),
      drawer: const MainDrawer(),
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
