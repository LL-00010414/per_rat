// database_provider.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:per_rat/data/models/anime.dart';

Future<List<Anime>> loadAnimeFromFirestore() async {
  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('anime').get();

  final List<Anime> loadedAnime = querySnapshot.docs
      .map((doc) {
        final data = doc.data()
            as Map<String, dynamic>?; // Cast to Map<String, dynamic>?

        if (data == null) {
          return null; // Handle the case where data is null
        }
        return Anime(
          id: doc.id,
          title: data['title'] ?? '',
          imageUrl: data['imageUrl'] ?? '',
          synopsis: List<String>.from(data['synopsis'] ?? []),
          totalEpisodes: data['totalEpisodes'] ?? 0,
          score: data['score'] ?? '0',
          rank: data['rank'] ?? '0',
          popularity: data['popularity'] ?? '0',
          favorites: data['favorites'] ?? 0,
          trailerUrl: data['trailerUrl'] ?? '',
          genre: List<String>.from(data['genre'] ?? []),
          demographic: data['demographic'] ?? 'unknown',
          studio: data['studio'] ?? 'unknown',
          status: data['status'] ?? 'unknown',
          startDate: DateTime.parse(
              data['startDate'] ?? DateTime(0)), // Parse startDate as DateTime
          endDate: data['endDate'] == ''
              ? DateTime(0)
              : DateTime.parse(data['endDate']), // Parse endDate as DateTime
        );
      })
      .where((anime) => anime != null)
      .cast<Anime>()
      .toList(); // Filter out null values and cast to List<Anime>

  return loadedAnime;
}

Future<void> removeAnime(
    BuildContext context, List<Anime> registeredAnime, Anime anime) async {
  final animeIndex = registeredAnime.indexOf(anime);
  await showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      backgroundColor: Colors.amberAccent,
      title: Text(anime.title),
      content: Text('Do you want to delete ${anime.title}?'),
      actions: <Widget>[
        OutlinedButton(
          onPressed: () async {
            try {
              await FirebaseFirestore.instance
                  .collection('anime')
                  .doc(anime.id)
                  .delete();

              registeredAnime.remove(anime);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 3),
                  content: Text("${anime.title} has been deleted"),
                ),
              );
            } catch (error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 3),
                  content: Text("Error deleting ${anime.title}: $error"),
                ),
              );
              registeredAnime.insert(animeIndex, anime);
            }
          },
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: Text(
            'Yes',
            style: TextStyle(color: Colors.red),
          ),
        ),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'No',
            style: TextStyle(color: Colors.green),
          ),
        ),
      ],
    ),
  );
}
