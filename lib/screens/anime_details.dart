import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:per_rat/data/firestore_data.dart';
import 'package:per_rat/models/anime.dart';
import 'package:per_rat/screens/edit_score_screen.dart';
import 'package:per_rat/widgets/showDetailsSkeleton.dart';
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
  bool _isLoading = true; // Add a loading state

  final user = FirebaseAuth.instance.currentUser!;
  bool movieExists = false;

  @override
  void initState() {
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
      _isLoading = false;
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
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text(widget.anime.title),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
          right: 8,
          bottom: 12,
        ),
        child: SizedBox(
          height: 65,
          width: 65,
          child: FloatingActionButton(
            backgroundColor: Colors.green,
            shape: CircleBorder(),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (ctx) => EditScoreScreen(
                          anime: widget.anime,
                        )),
              );
            },
            //icon: Icon(movieExists ? Icons.edit : Icons.add),
            child: Icon(movieExists ? Icons.edit : Icons.add),
          ),
        ),
      ),
      body: _isLoading
          ? shimmerShowSkeleton()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.network(
                      widget.anime.imageUrl,
                      height: 300,
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: Text(
                      widget.anime.title,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildInfoColumn(
                        'Score',
                        (double.tryParse(widget.anime.score) == 0)
                            ? 'N/A'
                            : widget.anime.score,
                        Icons.star_border,
                      ),
                      _buildInfoColumn(
                        'Rank',
                        (int.tryParse(widget.anime.rank) == 0)
                            ? 'N/A'
                            : widget.anime.rank,
                        Icons.leaderboard,
                      ),
                      _buildInfoColumn(
                        'Popularity',
                        widget.anime.popularity,
                        Icons.people,
                      ),
                      _buildInfoColumn(
                        'Favorites',
                        widget.anime.favorites.toString(),
                        Icons.favorite,
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  _buildStatusRow('Premiered',
                      '${formatterMY.format(widget.anime.startDate)}'),
                  _buildStatusRow('Status', widget.anime.status),
                  _buildStatusRow(
                      'Episodes', '${widget.anime.totalEpisodes.toString()}'),
                  SizedBox(height: 16),
                  _buildGenreChips(widget.anime.genre),
                  SizedBox(height: 16),
                  Text(
                    'Synopsis',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.anime.synopsis
                        .join()
                        .replaceAll('[', '"')
                        .replaceAll(']', '"'),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
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
                  SizedBox(height: 16),
                  Text(
                    'Similar Anime',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 97, 70, 152),
                    ),
                  ),
                  if (similarAnime.isEmpty)
                    Container(
                      height: 100,
                      alignment: Alignment.bottomCenter,
                      child: const Center(
                        child: Text(
                          'No similar anime were found!',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  if (similarAnime.isNotEmpty)
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
                  const SizedBox(
                    height: 30,
                  ),

                  // SizedBox(height: 8),
                  // _buildSimilarAnimeList(similarAnime),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoColumn(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenreChips(List<String> genres) {
    return Wrap(
      spacing: 8,
      children: genres
          .map((genre) => Chip(
                label: Text(genre.toUpperCase()),
                backgroundColor: Colors.redAccent,
              ))
          .toList(),
    );
  }
}
