import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:per_rat/models/anime.dart';
import 'package:per_rat/screens/anime_details.dart';
import 'package:per_rat/screens/edit_score_screen.dart';

class RealtimeSearchGpt extends StatefulWidget {
  const RealtimeSearchGpt({
    super.key,
  });

  @override
  State<RealtimeSearchGpt> createState() => _RealtimeSearchGptState();
}

class _RealtimeSearchGptState extends State<RealtimeSearchGpt> {
  var searchName = "";
  Timer? _debounce;
  DocumentSnapshot? lastVisible;

  final _scrollController = ScrollController();
  bool _isLoadingMore = false;
  List<QueryDocumentSnapshot> searchResults = [];

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        searchName = query;
        lastVisible = null;
        searchResults.clear();
      });
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

  Stream<List<QueryDocumentSnapshot>> searchAnime() async* {
    if (searchName.isEmpty) {
      yield [];
      return;
    }

    Query query = FirebaseFirestore.instance
        .collection('anime')
        .where('title', isGreaterThanOrEqualTo: searchName)
        .where('title', isLessThanOrEqualTo: searchName + '\uf8ff')
        .orderBy('popularity', descending: true) // Sorting by popularity
        .limit(20);

    if (lastVisible != null) {
      query = query.startAfterDocument(lastVisible!);
    }

    var snapshot = await query.get();
    lastVisible = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;

    searchResults.addAll(snapshot.docs);
    yield searchResults;
  }

  void _loadMore() {
    if (!_isLoadingMore && lastVisible != null) {
      setState(() {
        _isLoadingMore = true;
      });

      searchAnime().listen((results) {
        setState(() {
          _isLoadingMore = false;
          searchResults = results;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_isLoadingMore) {
        _loadMore();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('PERRAT'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            child: SizedBox(
              height: 50,
              child: TextField(
                onChanged: onSearchChanged,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer),
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
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<QueryDocumentSnapshot>>(
              stream: searchAnime(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Something went wrong'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (searchName.isEmpty || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      'No results found!',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  );
                }

                final results = snapshot.data!
                    .map((doc) {
                      final data = doc.data() as Map<String, dynamic>?;

                      if (data == null) {
                        return null;
                      }

                      return Anime(
                        id: doc.id,
                        title: data['title'],
                        imageUrl: data['imageUrl'],
                        synopsis: List<String>.from(data['synopsis']),
                        totalEpisodes: data['totalEpisodes'],
                        score: data['score'],
                        rank: data['rank'],
                        popularity: data['popularity'],
                        favorites: data['favorites'],
                        trailerUrl: data['trailerUrl'],
                        genre: List<String>.from(data['genre']),
                        demographic: data['demographic'],
                        studio: data['studio'],
                        status: data['status'],
                        startDate: DateTime.parse(data['startDate']),
                        endDate: DateTime.parse(data['endDate']),
                      );
                    })
                    .where((anime) => anime != null)
                    .toList();

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: results.length + 1,
                  itemBuilder: (context, index) {
                    if (index == results.length) {
                      return _isLoadingMore
                          ? Center(child: CircularProgressIndicator())
                          : SizedBox.shrink();
                    }

                    final anime = results[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.all(5),
                      minVerticalPadding: 10,
                      tileColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      leading: CircleAvatar(
                        radius: 24,
                        backgroundImage: NetworkImage(
                          anime!.imageUrl,
                        ),
                      ),
                      title: Text(anime.title),
                      isThreeLine: true,
                      trailing: IconButton.outlined(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (ctx) => EditScoreScreen(
                                        anime: anime,
                                      )),
                            );
                          },
                          icon: const Icon(Icons.edit_note_sharp)),
                      subtitle: Row(
                        children: [
                          Text('${anime.totalEpisodes.toString()} ep.'),
                          Text(
                            ' ${anime.status}',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.tertiary),
                          )
                        ],
                      ),
                      onTap: () {
                        pickAnime(context, anime);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
