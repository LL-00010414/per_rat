import 'package:flutter/material.dart';
import 'package:per_rat/data/movie_info.dart';
import 'package:per_rat/models/anime.dart';
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
  final List<String> videoURL =
      dummyAnime.map((anime) => anime.trailerUrl).toList();

  @override
  void initState() {
    //final animeIndex = dummyAnime.indexOf(widget.anime);
    // _registeredAnime.indexOf(anime);
    //final index = videoURL.length;
    //final videoID1 = YoutubePlayer.convertUrlToId(videoURL[animeIndex + 1]);
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
  }

  @override
  Widget build(BuildContext context) {
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
                  width: 150,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8, right: 8),
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
                          const Icon(Icons.star_border_rounded),
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
                                    Theme.of(context).colorScheme.onBackground,
                                fontWeight: FontWeight.normal,
                              ),
                        ),
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
                    'Premiered: ${widget.anime.formattedDate.substring(2)}',
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
            for (final description in widget.anime.synopsis)
              Text(
                description,
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
          ],
        ),
      ),
    );
  }
}
