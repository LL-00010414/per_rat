import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:per_rat/data/firestore_data.dart';
import 'package:per_rat/models/anime.dart';
import 'package:per_rat/models/show_rating.dart';
import 'package:per_rat/screens/new_anime.dart';
import 'package:per_rat/screens/show_rating_details.dart';
import 'package:per_rat/widgets/anime_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Anime> _registeredAnime = [];
  var _isLoading = true;
  String? _error;

  //getting user Ratings
  final user = FirebaseAuth.instance.currentUser!;
  List<ShowRating> _showratings = [];

  //getting Anime
  Anime? animeSet;

  void _fetchAnime() async {
    List<Anime> loadedAnime = await loadAnimeFromFirestore();
    setState(() {
      _registeredAnime = loadedAnime;
    });
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
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('ratings')
        .orderBy('timestamp', descending: true)
        .get();

    List<ShowRating> filteredRatings =
        querySnapshot.docs.map((doc) => ShowRating.fromFirestore(doc)).toList();

    setState(() {
      _showratings = filteredRatings;
    });
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

  void lastOnline() {
    var yourRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    yourRef.get().then((doc) => {
          if (!doc.exists)
            {print('No such document')}
          else
            {
              if (doc.get('last_online') != null)
                {
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid)
                      .update({
                    'last_online': Timestamp.now(),
                  })
                }
              else
                {
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid)
                      .set({
                    'last_online': Timestamp.now(),
                  })
                }
            }
        });
  }

  @override
  void initState() {
    super.initState();
    _fetchAnime();
    displayRating();
    lastOnline();
  }

  void _addAnime(Anime anime) {
    setState(() {
      _registeredAnime.add(anime);
    });
  }

  void _addAnimePage() async {
    final newAnime = await Navigator.of(context).push<Anime>(
      MaterialPageRoute(
        builder: (ctx) => NewAnime(onAddAnime: _addAnime),
      ),
    );

    if (newAnime == null) {
      return;
    }

    setState(() {
      _registeredAnime.add(newAnime);
    });
  }

  // void _removeAnime(Anime anime) async {
  //   await removeAnime(context, _registeredAnime, anime);
  //   setState(() {
  //     _registeredAnime = _registeredAnime;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    void selectRating(BuildContext context, ShowRating showRating) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => ShowDetailsScreen(
            showRating: showRating,
          ),
        ),
      );
    }

    // void editRating(BuildContext context, ShowRating showRating) {
    //   Navigator.of(context).push(MaterialPageRoute(
    //       builder: (ctx) => EditRatingsScreen(
    //             showRating: showRating,
    //           )));
    // }

    // void selectAnime(BuildContext context, Anime anime) {
    //   Navigator.of(context).push(
    //     MaterialPageRoute(
    //       builder: (ctx) => AnimeDetailsScreen(
    //         anime: anime,
    //       ),
    //     ),
    //   );
    // }

    Widget content = const Center(
      child: Text(
        'No shows are present',
        style: TextStyle(color: Colors.white),
      ),
    );

    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (_showratings.isNotEmpty) {
      content = GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.5,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
        ),
        itemCount: _showratings.length,
        itemBuilder: (context, index) {
          var rating = _showratings[index];
          // setState(() {
          //   animeSet = getAnimeFromShowrating(rating);
          // });
          animeSet = getAnimeFromShowrating(rating);
          if (animeSet == null) {
            return const Text('No ratings added');
          }
          return AnimeItem(
            showRating: rating,
            anime: animeSet!,
            onSelectRating: (rating) {
              selectRating(context, rating);
            },
            onDeleteRating: (rating) {
              deleteRating(rating);
            },
          );
          // AllAnimeItem(
          //     showRating: rating,
          //     onSelectRating: (rating) {
          //       selectRating(context, rating);
          //     },
          //     onEditRating: (showRating) {
          //       editRating(context, showRating);
          //     });
        },
      );
    }
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
        actions: [
          IconButton(
            onPressed: _addAnimePage,
            icon: const Icon(Icons.add_sharp),
          )
        ],
      ),
      body: content,
    );
  }
}
