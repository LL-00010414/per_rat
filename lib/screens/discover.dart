import 'package:flutter/material.dart';

import 'package:per_rat/data/movie_info.dart';
import 'package:per_rat/models/anime.dart';
import 'package:per_rat/screens/anime_details.dart';

import 'package:per_rat/widgets/discover_anime_item.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({
    super.key,
    required this.ongoingAnime,
    required this.trendingAnime,
    required this.upcomingAnime,
  });

  final List<Anime> ongoingAnime;
  final List<Anime> trendingAnime;
  final List<Anime> upcomingAnime;

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
  Widget build(BuildContext context) {
    // List<String> animeImages =
    //     dummyAnime.map((anime) => anime.imageUrl).toList();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 18, right: 18, top: 18),
              child: TextField(
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.normal,
                    ),
                onTap: () {
                  showSearch(context: context, delegate: MySearchDelegate());
                },
                decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromARGB(31, 133, 157, 177),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Type anime name',
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: Colors.amber,
                    ),
                    prefixIconColor: Colors.amberAccent),
              ),
            ),
            // const SizedBox(
            //   height: 10,
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(
            //     left: 18,
            //     right: 18,
            //     top: 8,
            //   ),
            //   child: Text(
            //     'Ongoing',
            //     style: Theme.of(context).textTheme.titleMedium!.copyWith(
            //           color: Theme.of(context).colorScheme.onBackground,
            //           fontWeight: FontWeight.normal,
            //         ),
            //   ),
            // ),
          ],
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
                  itemCount: ongoingAnime.length,
                  itemBuilder: (context, index) {
                    return DiscoverAnimeItem(
                      anime: ongoingAnime[index],
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
                  itemCount: trendingAnime.length,
                  itemBuilder: (context, index) {
                    return DiscoverAnimeItem(
                      anime: trendingAnime[index],
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
                  itemCount: upcomingAnime.length,
                  itemBuilder: (context, index) {
                    return DiscoverAnimeItem(
                      anime: upcomingAnime[index],
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

  final List<Anime> chosenAnime1 = dummyAnime;
  void pickAnime(BuildContext context, Anime anime) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => AnimeDetailsScreen(
          anime: anime,
        ),
      ),
    );
  }

  List<String> searchTerms = dummyAnime.map((anime) => anime.title).toList();
  List<String> searchHistory =
      dummyAnime.map((anime1) => anime1.title).take(4).toList();

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
    //final List<Anime> chosenAnime1 = dummyAnime;

    // void pickAnime1(BuildContext context, Anime anime) {
    //   Navigator.of(context).push(
    //     MaterialPageRoute(
    //       builder: (ctx) => AnimeDetailsScreen(
    //         anime: anime,
    //       ),
    //     ),
    //   );
    // }

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
          final List<Anime> searchResult =
              dummyAnime.where((a) => a.title.contains(result)).toList();
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
    //   final List<Anime> searchResult =
    // dummyAnime.where((a) => a.title.contains(result)).toList();

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        final result = matchQuery[index];
        final List<Anime> searchResult =
            dummyAnime.where((a1) => a1.title.contains(result)).toList();
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
