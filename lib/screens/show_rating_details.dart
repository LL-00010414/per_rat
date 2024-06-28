import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:per_rat/models/show_rating.dart';
import 'package:per_rat/screens/edit_ratings.dart';
import 'package:per_rat/widgets/show_rating_skeleton.dart';

import '../data/firestore_data.dart';
import '../models/anime.dart';
import '../widgets/similar_anime_item.dart';
import 'anime_details.dart';

class ShowDetailsScreen extends StatefulWidget {
  const ShowDetailsScreen({
    super.key,
    required this.showRating,
  });

  final ShowRating showRating;

  @override
  State<ShowDetailsScreen> createState() => _ShowDetailsScreenState();
}

class _ShowDetailsScreenState extends State<ShowDetailsScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  List<Anime> _registeredAnime = [];
  Anime? animeSet;
  bool _isLoading = true; // Add a loading state

  @override
  void initState() {
    super.initState();
    _fetchAnime();
  }

  void _fetchAnime() async {
    List<Anime> loadedAnime = await loadAnimeFromFirestore();
    setState(() {
      _registeredAnime = loadedAnime;
      animeSet = getAnimeFromShowRating(widget.showRating);
      _isLoading = false; // Update loading state
    });
  }

  Anime? getAnimeFromShowRating(ShowRating showRating) {
    for (Anime anime in _registeredAnime) {
      if (anime.title == showRating.showName) {
        return anime;
      }
    }
    return null;
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.showRating.showName),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: showRatingSkeleton,
        ),
      );
    }

    final List<Anime> similarAnime = _registeredAnime
        .where((anime) => anime.genre.any((g) => animeSet!.genre.contains(g)))
        .where((anime) => anime.title != animeSet!.title)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.showRating.showName),
      ),
      floatingActionButton: IconButton.outlined(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (ctx) => EditRatingsScreen(
                      showRating: widget.showRating,
                    )),
          );
        },
        style: IconButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 12, 88, 15),
          iconSize: 40,
        ),
        icon: Icon(Icons.edit),
        color: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.network(
                  animeSet!.imageUrl,
                  height: 300,
                  width: 200,
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  height: 300,
                  width: 150,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20, right: 8),
                        child: Text(
                          'Score',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.normal,
                              ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.star_border_rounded,
                            color:
                                Theme.of(context).colorScheme.onErrorContainer,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Text(
                              (double.tryParse(animeSet!.score) == 0)
                                  ? 'N/A'
                                  : animeSet!.score,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontWeight: FontWeight.normal,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 28, right: 8),
                        child: Text(
                          'Rank',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.normal,
                              ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.radar,
                            color:
                                Theme.of(context).colorScheme.onErrorContainer,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Text(
                              (int.tryParse(animeSet!.rank) == 0)
                                  ? 'N/A'
                                  : animeSet!.rank,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontWeight: FontWeight.normal,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 28, right: 8),
                        child: Text(
                          'Popularity',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.normal,
                              ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Text(
                          animeSet!.popularity,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.normal,
                              ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 28, right: 8),
                        child: Text(
                          'Favorites',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.normal,
                              ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Text(
                          animeSet!.favorites.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.normal,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.only(
                top: 15,
                bottom: 15,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Premiered: ${formatterMY.format(animeSet!.startDate)}',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                  Text(
                    animeSet!.status,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                  Text(
                    'Episodes: ${animeSet!.totalEpisodes.toString()}',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 15,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Genre: ${animeSet!.genre.map((g) => g.toUpperCase()).join(', ')}',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ),
            Text(
              'Synopsis',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              animeSet!.synopsis
                  .join()
                  .replaceAll('[', '"')
                  .replaceAll(']', '"'),
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    'Similar Titles:',
                    style:
                        Theme.of(context).primaryTextTheme.titleLarge!.copyWith(
                              color: Colors.amber,
                            ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 240,
              child: ListView.builder(
                itemExtent: 155,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(
                    left: 5, right: 15, top: 15, bottom: 10),
                itemCount: similarAnime.length,
                itemBuilder: (context, index) {
                  return SimilarAnimeItem(
                    anime: similarAnime[index],
                    onPickAnime: (anime) {
                      pickAnime(context, anime);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
