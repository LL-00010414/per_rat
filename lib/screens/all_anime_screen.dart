import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:per_rat/models/anime.dart';
import 'package:per_rat/screens/anime_details.dart';
import 'package:per_rat/screens/edit_score_screen.dart';
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

  @override
  Widget build(BuildContext context) {
    void selectAnime(BuildContext context, Anime anime) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => AnimeDetailsScreen(
            anime: anime,
          ),
        ),
      );
    }

    void editScore(BuildContext context, Anime anime) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => EditScoreScreen(
                anime: anime,
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

          final ratingsDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: ratingsDocs.length,
            itemBuilder: (context, index) {
              var ratingData =
                  ratingsDocs[index].data() as Map<String, dynamic>;

              //storing show fields inside variables
              final showName = ratingsDocs[index].id;
              final showStatus = ratingData['status'];
              final showProgress = ratingData['progress'];
              final showScore = ratingData['score'];
              return ListTile(
                title: Text(showName),
                subtitle: Text(
                  'Status: $showStatus, '
                  'Progress: $showProgress, '
                  'Score: $showScore',
                ),
                trailing: Text(
                  ratingData['timestamp'] != null
                      ? (ratingData['timestamp'] as Timestamp)
                          .toDate()
                          .toString()
                      : 'No timestamp',
                ),
                onTap: () {},
              );
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
