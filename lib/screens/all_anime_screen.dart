import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:per_rat/models/anime.dart';
import 'package:per_rat/models/show_rating.dart';

import 'package:per_rat/screens/edit_ratings.dart';

import 'package:per_rat/screens/show_rating_details.dart';
import 'package:per_rat/widgets/all_anime_item.dart';

class AllAnimeScreen extends StatefulWidget {
  const AllAnimeScreen({
    super.key,
    required this.myAnimeList,
  });

  final List<Anime> myAnimeList;

  @override
  State<AllAnimeScreen> createState() => _AllAnimeScreenState();
}

class _AllAnimeScreenState extends State<AllAnimeScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  List<ShowRating> _showratings = [];

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

  @override
  void initState() {
    super.initState();
    displayRating();
  }

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

    void editRating(BuildContext context, ShowRating showRating) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => EditRatingsScreen(
                showRating: showRating,
              )));
    }

    return Scaffold(
      // appBar: AppBar(
      //     title: Text('User Ratings'),
      //     ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('ratings')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No ratings found.'));
          }

          //final ratingsDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: _showratings.length,
            itemBuilder: (context, index) {
              //old way of getting data
              // var ratingData =
              //     ratingsDocs[index].data() as Map<String, dynamic>;
              //storing show fields inside variables
              // final showName = ratingsDocs[index].id;
              // final showStatus = ratingData['status'];
              // final showProgress = ratingData['progress'];
              // final showScore = ratingData['score'];

              //new model type way
              var rating = _showratings[index];
              return AllAnimeItem(
                  showRating: rating,
                  onSelectRating: (rating) {
                    selectRating(context, rating);
                  },
                  onEditRating: (showRating) {
                    editRating(context, showRating);
                  });

              // ListTile(
              //   title: Text(showName),
              //   subtitle: Text(
              //     'Status: $showStatus, '
              //     'Progress: $showProgress, '
              //     'Score: $showScore',
              //   ),
              //   trailing: Text(
              //     ratingData['timestamp'] != null
              //         ? (ratingData['timestamp'] as Timestamp)
              //             .toDate()
              //             .toString()
              //         : 'No timestamp',
              //   ),
              //   onTap: () {},
              // );
            },
          );
        },
      ),
    );
  }

  // Widget content = const Center(
  //   child: Text(
  //     '...',
  //     style: TextStyle(color: Colors.amber),
  //   ),
  // );
  // if (widget.myAnimeList.isNotEmpty) {
  //   content = ListView.builder(
  //       itemCount: widget.myAnimeList.length,
  //       itemBuilder: (ctx, index) => AllAnimeItem(
  //             anime: widget.myAnimeList[index],
  //             onSelectAnime: (anime) {
  //               selectAnime(context, anime);
  //             },
  //             onEditScore: (anime) {
  //               editScore(context, anime);
  //             },
  //           ));
  // }

  // return Scaffold(
  //   body: content,
  // );
}
