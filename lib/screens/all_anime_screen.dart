import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:per_rat/data/firestore_data.dart';
import 'package:per_rat/models/anime.dart';
import 'package:per_rat/models/show_rating.dart';
import 'package:per_rat/screens/edit_ratings.dart';
import 'package:per_rat/screens/show_rating_details_screen.dart';
import 'package:per_rat/widgets/all_anime_item.dart';
import 'package:per_rat/widgets/all_anime_item_skeleton.dart';

class AllAnimeScreen extends StatefulWidget {
  const AllAnimeScreen({
    super.key,
  });

  @override
  State<AllAnimeScreen> createState() => _AllAnimeScreenState();
}

class _AllAnimeScreenState extends State<AllAnimeScreen> {
  List<Anime> _registeredAnime = [];
  String? _error;
  bool _isLoading = true; // Add a loading state

  //getting user Ratings
  final user = FirebaseAuth.instance.currentUser!;
  List<ShowRating> _showratings = [];

  //getting Anime
  Anime? animeSet;

  void _fetchAnime() async {
    try {
      List<Anime> loadedAnime = await loadAnimeFromFirestore();
      setState(() {
        _registeredAnime = loadedAnime;
        // _isLoading = false;
      });
      _checkLoadingState();
    } catch (e) {
      setState(() {
        _error = 'Failed to load anime: $e';
        _isLoading = false;
      });
    }
  }

  Anime? getAnimeFromShowrating(ShowRating showrating) {
    for (Anime anime in _registeredAnime) {
      if (anime.title == showrating.showName) {
        return anime;
      }
    }
    return null;
  }

  Future<void> displayRating() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('ratings')
          .orderBy('timestamp', descending: true)
          .get();

      List<ShowRating> filteredRatings = querySnapshot.docs
          .map((doc) => ShowRating.fromFirestore(doc))
          .toList();

      setState(() {
        _showratings = filteredRatings;
      });
      _checkLoadingState();
    } catch (e) {
      setState(() {
        _error = 'Failed to load ratings: $e';
        _isLoading = false;
      });
    }
  }

  // Check if both anime and ratings have been loaded
  void _checkLoadingState() {
    if (_registeredAnime.isNotEmpty ||
        _showratings.isNotEmpty ||
        _error != null) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchAnime();
    displayRating();

    // Set a timer to stop showing the skeleton after a limited time
    // Timer(Duration(seconds: 3), () {
    // setState(() {
    //   _isLoading = false;
    // });
    // });
  }

  @override
  Widget build(BuildContext context) {
    void selectRating(BuildContext context, ShowRating showRating) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => ShowRatingDetails(
            showRating: showRating,
          ),
        ),
      );
    }

    void editRating(BuildContext context, ShowRating showRating) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => EditRatingsScreen(
                showRating: showRating,
              )));
    }

    Widget content = _isLoading
        ? SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: allAnimeSkeleton,
            ),
          )
        : _showratings.isEmpty
            ? Center(
                child: Text(
                  'No anime added',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              )
            : ListView.builder(
                itemCount: _showratings.length,
                itemBuilder: (context, index) {
                  var rating = _showratings[index];
                  animeSet = getAnimeFromShowrating(rating);

                  // Skip rendering if no matching anime is found
                  if (animeSet == null) {
                    return SizedBox.shrink(); // Returns an empty widget
                  }
                  return AllAnimeItem(
                      showRating: rating,
                      anime: animeSet!,
                      onSelectRating: (rating) {
                        selectRating(context, rating);
                      },
                      onEditRating: (showRating) {
                        editRating(context, showRating);
                      });
                },
              );

    if (_error != null) {
      content = Center(
        child: Text(
          _error!,
          style: const TextStyle(color: Colors.white),
        ),
      );
    }

    return Scaffold(
      body: content,
    );

    // final Stream<QuerySnapshot> dataStream = FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(user.uid)
    //     .collection('ratings')
    //     .orderBy('timestamp', descending: true)
    //     .snapshots();

    // return Scaffold(
    //   body: StreamBuilder<QuerySnapshot>(
    //     stream: dataStream,
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return Center(child: CircularProgressIndicator());
    //       }

    //       if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
    //         return Center(
    //             child: Text(
    //           'No ratings found.',
    //           style: TextStyle(
    //             color: Theme.of(context).colorScheme.primary,
    //           ),
    //         ));
    //       }

    //       return content;
    //     },
    //   ),
    // );
  }
}
