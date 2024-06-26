import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:per_rat/data/firestore_data.dart';
import 'package:per_rat/models/anime.dart';
import 'package:per_rat/screens/edit_score_screen.dart';
import 'package:per_rat/widgets/similar_anime_item.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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
  List<Anime> _registeredAnime = [];

  //changing button type
  final user = FirebaseAuth.instance.currentUser!;
  bool movieExists = false;

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

    checkIfMovieExists();
    _fetchAnime();
  }

  void _fetchAnime() async {
    List<Anime> loadedAnime = await loadAnimeFromFirestore();
    setState(() {
      _registeredAnime = loadedAnime;
    });
  }

  Future<void> checkIfMovieExists() async {
    try {
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      CollectionReference ratingCollectionRef =
          userDocRef.collection('ratings');

      DocumentSnapshot docSnapshot =
          await ratingCollectionRef.doc(widget.anime.title).get();
      setState(() {
        movieExists = docSnapshot.exists;
      });
    } catch (error) {
      print("Error checking movie existence: $error");
    }
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
    final List<Anime> similarAnime = _registeredAnime
        .where(
            (anime) => anime.genre.any((g) => widget.anime.genre.contains(g)))
        .where((anime) => anime.title != widget.anime.title)
        .toList();

    return Scaffold(
      //backgroundColor: const Color.fromARGB(255, 56, 22, 205),
      appBar: AppBar(
        title: Text(widget.anime.title),
      ),
      floatingActionButton: IconButton.outlined(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (ctx) => EditScoreScreen(
                      anime: widget.anime,
                    )),
          );
        },
        style: IconButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 12, 88, 15),
          iconSize: 40,
        ),
        icon: Icon(movieExists ? Icons.edit : Icons.add),
        color: Colors.white,
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
                              (double.tryParse(widget.anime.score) == 0)
                                  ? 'N/A'
                                  : widget.anime.score,
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
                              (int.tryParse(widget.anime.rank) == 0)
                                  ? 'N/A'
                                  : widget.anime.rank,
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
                          widget.anime.popularity,
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
                          widget.anime.favorites.toString(),
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
                    'Premiered: ${formatterMY.format(widget.anime.startDate)}',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                  Text(
                    widget.anime.status,
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
                    'Genre: ${widget.anime.genre.map((g) => g.toUpperCase()).join(', ')}',
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
                    color: Theme.of(context).colorScheme.onSurface,
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
