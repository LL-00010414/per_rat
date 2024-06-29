import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:per_rat/data/firestore_data.dart';
import 'package:per_rat/data/firestore_service.dart';
import 'package:per_rat/models/anime.dart';
import 'package:per_rat/models/show_rating.dart';
import 'package:per_rat/screens/show_rating_details_screen.dart';
import 'package:per_rat/widgets/home_anime_item.dart';
import 'package:per_rat/widgets/home_anime_skeleton.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final FirestoreService _firestoreService =
      FirestoreService(); // Initialize the Firestore service
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
        _isLoading = false;
      });
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
    } catch (e) {
      setState(() {
        _error = 'Failed to load ratings: $e';
      });
    }
  }

  Future<void> deleteRating(ShowRating showRating) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('ratings')
          .doc(showRating.showName) // Assuming showName is the document ID
          .delete();

      setState(() {
        _showratings.remove(showRating);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${showRating.showName} has been deleted'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting ${showRating.showName}: $e'),
        ),
      );
    }
  }

  // void lastOnline() {
  //   var yourRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
  //   yourRef.get().then((doc) => {
  //         if (!doc.exists)
  //           {print('No such document')}
  //         else
  //           {
  //             if (doc.get('last_online') != null)
  //               {
  //                 FirebaseFirestore.instance
  //                     .collection('users')
  //                     .doc(user.uid)
  //                     .update({
  //                   'last_online': Timestamp.now(),
  //                 })
  //               }
  //             else
  //               {
  //                 FirebaseFirestore.instance
  //                     .collection('users')
  //                     .doc(user.uid)
  //                     .set({
  //                   'last_online': Timestamp.now(),
  //                 })
  //               }
  //           }
  //       });
  // }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _firestoreService.setUserOnlineStatus(true); // Set user status to online
    _fetchAnime();
    displayRating();
    //lastOnline();

    // Set a timer to stop showing the skeleton after a limited time
    Timer(Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _firestoreService.setUserOnlineStatus(
          false); // Set user status to offline when the app is paused or inactive
    } else if (state == AppLifecycleState.resumed) {
      _firestoreService.setUserOnlineStatus(
          true); // Set user status to online when the app is resumed
    }
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

    Widget content = _isLoading
        ? SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: homeSkeleton,
            ),
          )
        : _showratings.isEmpty
            ? Center(
                child: Text(
                  'No anime added',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              )
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.5,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                ),
                itemCount: _showratings.length,
                itemBuilder: (context, index) {
                  var rating = _showratings[index];
                  animeSet = getAnimeFromShowrating(rating);
                  if (animeSet == null) {
                    return const Text('No ratings added');
                  }
                  return HomeAnimeItem(
                    showRating: rating,
                    anime: animeSet!,
                    onSelectRating: (rating) {
                      selectRating(context, rating);
                    },
                    onDeleteRating: (rating) {
                      deleteRating(rating);
                    },
                  );
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
      appBar: AppBar(
        title: const Text('HOME'),
        actions: [],
      ),
      body: content,
    );
  }
}
