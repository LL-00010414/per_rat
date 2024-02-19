import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:per_rat/data/demographic_info.dart';
import 'package:per_rat/data/genre_info.dart';

import 'package:per_rat/data/status_info.dart';
import 'package:per_rat/data/studio_info.dart';
import 'package:per_rat/models/anime.dart';
import 'package:per_rat/screens/anime_details.dart';
import 'package:http/http.dart' as http;
import 'package:per_rat/screens/search_results.dart';

import 'package:per_rat/widgets/discover_anime_item.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({
    super.key,
    required this.ongoingAnime,
    required this.trendingAnime,
    required this.upcomingAnime,
  });

  final List<Anime> ongoingAnime;
  final List<Anime> trendingAnime;
  final List<Anime> upcomingAnime;

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  List<Anime> registeredAnime = [];
  var searchName = '';

  @override
  void initState() {
    super.initState();
    loadAnime();
  }

  void loadAnime() async {
    final url = Uri.https(
        'perratauth-default-rtdb.asia-southeast1.firebasedatabase.app',
        'movie-list.json');
    final response = await http.get(url);

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
      registeredAnime = loadedAnime;
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

  // void tapSearch(BuildContext context) {
  //   Navigator.of(context).pushReplacement(
  //       MaterialPageRoute(builder: (ctx) => SearchResultsScreen()));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: SizedBox(
          height: 40,
          child: TextField(
            onChanged: (value) {
              setState(() {
                searchName = value;
              });
            },
            onTap: () {
              // tapSearch(context);
            },
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                filled: true,
                fillColor: Color.fromARGB(255, 39, 39, 39),
                hintText: 'Search',
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey,
                )),
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 18,
                  right: 18,
                  top: 8,
                ),
                child: Text(
                  'Ongoing',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontWeight: FontWeight.normal,
                      ),
                ),
              ),
              SizedBox(
                height: 300,
                child: ListView.builder(
                  //itemExtent: 155,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(
                      left: 15, right: 15, top: 15, bottom: 10),
                  itemCount: widget.ongoingAnime.length,
                  itemBuilder: (context, index) {
                    return DiscoverAnimeItem(
                      anime: widget.ongoingAnime[index],
                      onPickAnime: (anime) {
                        pickAnime(context, anime);
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 18,
                  right: 18,
                  top: 8,
                ),
                child: Text(
                  'Trending',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontWeight: FontWeight.normal,
                      ),
                ),
              ),
              SizedBox(
                height: 300,
                child: ListView.builder(
                  //itemExtent: 155,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(
                      left: 15, right: 15, top: 15, bottom: 10),
                  itemCount: widget.trendingAnime.length,
                  itemBuilder: (context, index) {
                    return DiscoverAnimeItem(
                      anime: widget.trendingAnime[index],
                      onPickAnime: (anime) {
                        pickAnime(context, anime);
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 18,
                  right: 18,
                  top: 8,
                ),
                child: Text(
                  'Upcoming',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontWeight: FontWeight.normal,
                      ),
                ),
              ),
              SizedBox(
                height: 300,
                child: ListView.builder(
                  //itemExtent: 155,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(
                      left: 15, right: 15, top: 15, bottom: 10),
                  itemCount: widget.upcomingAnime.length,
                  itemBuilder: (context, index) {
                    return DiscoverAnimeItem(
                      anime: widget.upcomingAnime[index],
                      onPickAnime: (anime) {
                        pickAnime(context, anime);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MySearchDelegate extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    // Customize the text color here
    final ThemeData theme1 = Theme.of(context);
    return theme1.copyWith(
      primaryColor:
          Colors.blue, // Change the color of the search icon and cursor
      textTheme: const TextTheme(
        // Change the color of the input text
        titleLarge: TextStyle(
          color: Colors.amber, // Change the text color here
        ),
      ),
    );
  }

  List<String> searchTerms = _DiscoverScreenState()
      .registeredAnime
      .map((anime) => anime.title)
      .toList();

  List<String> searchHistory = _DiscoverScreenState()
      .registeredAnime
      .map((anime1) => anime1.title)
      .take(4)
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

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          if (query.isNotEmpty) {
            query = '';
          } else {
            close(context, null);
          }
        },
        icon: const Icon(Icons.clear_rounded),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    Widget resultContent = const Center(
      child: Text('No results...'),
    );

    List<String> matchQuery = [];
    for (final showName in searchTerms) {
      if (showName.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(showName);
      }
    }

    if (matchQuery.isNotEmpty) {
      resultContent = ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          var result = matchQuery[index];
          final List<Anime> searchResult = _DiscoverScreenState()
              .registeredAnime
              .where((a) => a.title.contains(result))
              .toList();
          return ListTile(
            leading: const CircleAvatar(
              child: Text('ア'),
            ),
            onTap: () {
              pickAnime(
                context,
                searchResult[index],
              );
            },
            textColor: Colors.amberAccent,
            title: Text(result),
          );
        },
      );
    }
    return Scaffold(
      body: resultContent,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (final showName in searchHistory) {
      if (showName.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(showName);
      }
    }

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        final result = matchQuery[index];
        final List<Anime> searchResult = _DiscoverScreenState()
            .registeredAnime
            .where((a1) => a1.title.contains(result))
            .toList();
        return ListTile(
          leading: const CircleAvatar(
            child: Text('ア'),
          ),
          onTap: () {
            pickAnime(
              context,
              searchResult[index],
            );
          },
          textColor: Colors.amberAccent,
          title: Text(result),
        );
      },
    );
  }
}
