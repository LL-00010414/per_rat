import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:per_rat/data/demographic_info.dart';
import 'package:per_rat/data/genre_info.dart';

import 'package:per_rat/data/status_info.dart';
import 'package:per_rat/data/studio_info.dart';
import 'package:per_rat/models/anime.dart';

import 'package:per_rat/widgets/similar_anime_item.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;

class AnimeDetailsScreen extends StatefulWidget {
  const AnimeDetailsScreen({
    super.key,
    required this.anime,
  });

  final Anime anime;

  @override
  State<AnimeDetailsScreen> createState() => _AnimeDetailsScreenState();
}

class _AnimeDetailsScreenState extends State<AnimeDetailsScreen> {
  late YoutubePlayerController _controller;
  List<Anime> registeredAnime = [];

  @override
  void initState() {
    //final animeIndex = dummyAnime.indexOf(widget.anime);

    final videoID = YoutubePlayer.convertUrlToId(widget.anime.trailerUrl);

    _controller = YoutubePlayerController(
      initialVideoId: videoID!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        //controlsVisibleAtStart: true,
        loop: false,
        forceHD: false,
        showLiveFullscreenButton: false,
      ),
    );
    super.initState();
    loadAnime();
  }

  void loadAnime() async {
    final url = Uri.https(
        'perratauth-default-rtdb.asia-southeast1.firebasedatabase.app',
        'anime-list.json');
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Anime> similarAnime = registeredAnime
        .where((anime) => anime.genre.title.contains(widget.anime.genre.title))
        .where((anime) => anime.title != widget.anime.title)
        .toList();
    return Scaffold(
      //backgroundColor: const Color.fromARGB(255, 56, 22, 205),
      appBar: AppBar(
        title: Text(widget.anime.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.network(
                  widget.anime.imageUrl,
                  height: 300,
                  width: 200,
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  height: 300,
                  width: 175,
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
                                color:
                                    Theme.of(context).colorScheme.onBackground,
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
                              (double.tryParse(widget.anime.score) == 0)
                                  ? 'N/A'
                                  : widget.anime.score,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
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
                                color:
                                    Theme.of(context).colorScheme.onBackground,
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
                              (int.tryParse(widget.anime.rank) == 0)
                                  ? 'N/A'
                                  : widget.anime.rank,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
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
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                fontWeight: FontWeight.normal,
                              ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Text(
                          widget.anime.popularity,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
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
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                fontWeight: FontWeight.normal,
                              ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Text(
                          widget.anime.favorites.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
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
                    'Premiered: ${formatterMY.format(widget.anime.startDate)}',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                  Text(
                    widget.anime.status.title,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                  Text(
                    'Episodes: ${widget.anime.totalEpisodes.toString()}',
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
                    'Genre: ${widget.anime.genre.title.toUpperCase()}',
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
            //the loop was for displaying List<String>
            //for (final description in widget.anime.synopsis)
            Text(
              //textAlign: TextAlign.left,
              widget.anime.synopsis
                  .join()
                  .replaceAll('[', '"')
                  .replaceAll(']', '"'),
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
            const SizedBox(
              height: 20,
            ),
            AspectRatio(
              aspectRatio: 16 / 9,
              child: YoutubePlayer(
                //actionsPadding: const EdgeInsets.all(15),
                controller: _controller,
                showVideoProgressIndicator: true,
                aspectRatio: PlaybackRate.normal,
                bottomActions: [
                  CurrentPosition(),
                  ProgressBar(
                    isExpanded: true,
                    colors: const ProgressBarColors(
                      playedColor: Colors.amber,
                      handleColor: Colors.red,
                    ),
                  ),
                  const PlaybackSpeedButton(),
                  PlayPauseButton(),
                ],
              ),
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
