import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:per_rat/data/firestore_data.dart';
import 'package:per_rat/data/firestore_service.dart';
import 'package:per_rat/data/messaging_service.dart';
import 'package:per_rat/models/anime.dart';
import 'package:per_rat/models/show_rating.dart';
import 'package:per_rat/screens/show_rating_details_screen.dart';
import 'package:per_rat/widgets/home_anime_skeleton.dart';
import 'package:per_rat/widgets/new_home_anime_item.dart';

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

  //chat
  final MessagingService _messagingService = MessagingService();

  //selection mode
  bool _isSelectionMode = false;
  List<ShowRating> _selectedRatings = [];

  void _fetchAnime() async {
    try {
      List<Anime> loadedAnime = await loadAnimeFromFirestore();
      setState(() {
        _registeredAnime = loadedAnime;
        //_isLoading = false;
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
    } catch (e) {
      setState(() {
        _error = 'Failed to load ratings: $e';
        _isLoading = false;
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

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Selected ratings have been deleted'),
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

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      if (!_isSelectionMode) {
        _selectedRatings.clear();
      }
    });
  }

  void _toggleRatingSelection(ShowRating rating) {
    setState(() {
      if (_selectedRatings.contains(rating)) {
        _selectedRatings.remove(rating);
      } else {
        _selectedRatings.add(rating);
      }
    });
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
    WidgetsBinding.instance.addObserver(this);
    _firestoreService.setUserOnlineStatus(true); // Set user status to online
    _initializeData();
    _fetchAnime();
    displayRating();
    _messagingService.initialize();
  }

  Future<void> _initializeData() async {
    try {
      await _firestoreService.uploadUserMetadata();
    } catch (e) {
      setState(() {
        _error = 'Failed to upload user metadata: $e';
      });
    }
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
                  return GestureDetector(
                    onLongPress: () {
                      _toggleSelectionMode();
                      _toggleRatingSelection(rating);
                    },
                    onTap: () {
                      if (_isSelectionMode) {
                        _toggleRatingSelection(rating);
                      } else {
                        selectRating(context, rating);
                      }
                    },
                    child: NewHomeAnimeItem(
                      showRating: rating,
                      anime: animeSet!,
                      isSelected: _selectedRatings.contains(rating),
                      onDeleteRating: (rating) {
                        deleteRating(rating);
                      },
                    ),
                  );

                  // return HomeAnimeItem(
                  //   showRating: rating,
                  //   anime: animeSet!,
                  //   onSelectRating: (rating) {
                  //     selectRating(context, rating);
                  //   },
                  //   onDeleteRating: (rating) {
                  //     deleteRating(rating);
                  //   },
                  // );
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
        actions: _isSelectionMode
            ? [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    for (var rating in _selectedRatings) {
                      deleteRating(rating);
                    }
                    _toggleSelectionMode();
                  },
                ),
              ]
            : [],
      ),
      body: content,
      floatingActionButton: _isSelectionMode
          ? FloatingActionButton(
              onPressed: _toggleSelectionMode,
              child: const Icon(Icons.close),
            )
          : null,
    );
  }
}
