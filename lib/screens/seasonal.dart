import 'package:flutter/material.dart';
import 'package:per_rat/data/firestore_data.dart';
import 'package:per_rat/models/anime.dart';
import 'package:per_rat/screens/anime_details.dart';
import 'package:per_rat/screens/dated_anime_screen.dart';
import 'package:per_rat/screens/edit_score_screen.dart';
import 'package:per_rat/widgets/archive_anime_item.dart';
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
  List<Anime> _registeredAnime = [];
  var _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _fetchAnime();
  }

  void _fetchAnime() async {
    List<Anime> loadedAnime = await loadAnimeFromFirestore();
    setState(() {
      _registeredAnime = loadedAnime;
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

  void pickSeason(List<Anime> datedAnime, String animeYM) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => DatedAnimeScreen(
              datedAnime: datedAnime,
              animeYM: animeYM,
            )));
  }

  void editScore(BuildContext context, Anime anime) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => EditScoreScreen(
              anime: anime,
            )));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Anime> lastAnime = _registeredAnime
        .where((anime) => anime.status.contains('Completed'))
        .toList();
    final List<Anime> thisSeaAnime = _registeredAnime
        .where((anime1) => anime1.status.contains('Ongoing'))
        .toList();
    final List<Anime> nextAnime = _registeredAnime
        .where((anime1) => anime1.status.contains('Upcoming'))
        .toList();

    //archive tab

    final numOfYears =
        _registeredAnime.map((anime) => anime.startDate.year).toSet().toList();
    numOfYears.sort((a, b) => b.compareTo(a));
    _registeredAnime.sort((a, b) => b.startDate.compareTo(a.startDate));
    // final numOfSeasons =
    //     _registeredAnime.map((anime) => anime.startDate).toList();
    // numOfSeasons.sort((a, b) => b.compareTo(a));

    // _registeredAnime
    //     .forEach((element) => print('${element.title}: ${element.startDate}'));

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
          crossAxisSpacing: 0,
          mainAxisSpacing: 3,
        ),
        itemCount: lastAnime.length,
        itemBuilder: (ctx, index) => SeasonalAnimeItem(
          anime: lastAnime[index],
          onPickAnime: (anime) {
            pickAnime(context, anime);
          },
          onEditScore: (anime) {
            editScore(context, anime);
          },
        ),
      );
    }
    if (_error != null) {
      lastContent = Center(
        child: Text(
          _error!,
          style: const TextStyle(color: Colors.white),
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
          onEditScore: (anime) {
            editScore(context, anime);
          },
        ),
      );
    }
    if (_error != null) {
      thisSeaContent = Center(
        child: Text(
          _error!,
          style: const TextStyle(color: Colors.white),
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
          onEditScore: (anime) {
            editScore(context, anime);
          },
        ),
      );
    }
    if (_error != null) {
      nextContent = Center(
        child: Text(
          _error!,
          style: const TextStyle(color: Colors.white),
        ),
      );
    }
    //archive tab

    Widget archContent = ListView(
      children: <Widget>[
        Column(
          children: [
            for (final year in numOfYears)
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      year.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 22),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ArchiveAnimeItem(
                        onPickSeason: (datedAnime) {
                          pickSeason(datedAnime, 'Winter $year');
                        },
                        animeSeason: 'Winter',
                        datedAnime: _registeredAnime
                            .where((anime) =>
                                (anime.startDate.isAfter(DateTime(year, 1, 1))))
                            .where((anime) =>
                                anime.startDate.isBefore(DateTime(year, 4, 1)))
                            .toList(),
                      ),
                      ArchiveAnimeItem(
                        onPickSeason: (datedAnime) {
                          pickSeason(datedAnime, 'Spring $year');
                        },
                        animeSeason: 'Spring',
                        datedAnime: _registeredAnime
                            .where((anime) =>
                                (anime.startDate.isAfter(DateTime(year, 4, 1))))
                            .where((anime) =>
                                anime.startDate.isBefore(DateTime(year, 7, 1)))
                            .toList(),
                      ),
                      ArchiveAnimeItem(
                        onPickSeason: (datedAnime) {
                          pickSeason(datedAnime, 'Summer $year');
                        },
                        animeSeason: 'Summer',
                        datedAnime: _registeredAnime
                            .where((anime) =>
                                (anime.startDate.isAfter(DateTime(year, 7, 1))))
                            .where((anime) =>
                                anime.startDate.isBefore(DateTime(year, 10, 1)))
                            .toList(),
                      ),
                      ArchiveAnimeItem(
                        onPickSeason: (datedAnime) {
                          pickSeason(datedAnime, 'Fall $year');
                        },
                        animeSeason: 'Fall',
                        datedAnime: _registeredAnime
                            .where((anime) => (anime.startDate
                                .isAfter(DateTime(year, 10, 1))))
                            .where((anime) => anime.startDate
                                .isBefore(DateTime(year, 12, 31)))
                            .toList(),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        )
      ],
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
          Center(
            child: archContent,
          ),
        ],
      ),
    );
  }
}
