import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:per_rat/models/show_rating.dart';
import 'package:per_rat/screens/edit_ratings.dart';
import 'package:per_rat/screens/show_rating_details.dart';
import 'package:per_rat/widgets/all_anime_item.dart';

class GenericAnimeScreen extends StatefulWidget {
  const GenericAnimeScreen({
    super.key,
    required this.filterStatus,
    required this.refreshParent,
  });

  final String filterStatus;
  final VoidCallback refreshParent;

  @override
  State<GenericAnimeScreen> createState() => _GenericAnimeScreenState();
}

class _GenericAnimeScreenState extends State<GenericAnimeScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  List<ShowRating> _showratings = [];

  Future<void> displayRating() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('ratings')
        .where('status', isEqualTo: widget.filterStatus)
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
                refreshParent: widget.refreshParent,
              )));
    }

    Widget content = ListView.builder(
      itemCount: _showratings.length,
      itemBuilder: (context, index) {
        var rating = _showratings[index];
        return AllAnimeItem(
            showRating: rating,
            onSelectRating: (rating) {
              selectRating(context, rating);
            },
            onEditRating: (showRating) {
              editRating(context, showRating);
            });
      },
    );

    final Stream<QuerySnapshot> dataStream = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('ratings')
        .where('status', isEqualTo: widget.filterStatus)
        .orderBy('timestamp', descending: true)
        .snapshots();

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: dataStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
                child: Text(
              'No ratings found.',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ));
          }

          return content;
        },
      ),
    );
  }
}
