import 'package:flutter/material.dart';
import 'package:per_rat/data/movie_info.dart';
import 'package:per_rat/models/anime.dart';
import 'package:per_rat/screens/anime_details.dart';
import 'package:per_rat/widgets/seasonal_anime_item.dart';

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Anime> lastAnime = dummyAnime
        .where((anime) => anime.status.title.contains('Completed'))
        .toList();
    final List<Anime> thisSeaAnime = dummyAnime
        .where((anime1) => anime1.status.title.contains('Ongoing'))
        .toList();
    final List<Anime> nextAnime = dummyAnime
        .where((anime1) => anime1.status.title.contains('Upcoming'))
        .toList();

    void pickAnime(BuildContext context, Anime anime) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => AnimeDetailsScreen(
            anime: anime,
          ),
        ),
      );
    }

    Widget lastContent = GridView.builder(
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

    Widget thisSeaContent = GridView.builder(
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

    Widget nextContent = GridView.builder(
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
