import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:per_rat/data/demographic_info.dart';
import 'package:per_rat/data/genre_info.dart';
import 'package:per_rat/data/status_info.dart';
import 'package:per_rat/data/studio_info.dart';
import 'package:per_rat/models/anime.dart';
import 'package:per_rat/screens/anime_details.dart';
import 'package:per_rat/screens/edit_score_screen.dart';

class RealtimeSearchScreen extends StatefulWidget {
  const RealtimeSearchScreen({
    super.key,
  });

  @override
  State<RealtimeSearchScreen> createState() => _RealtimeSearchScreenState();
}

class _RealtimeSearchScreenState extends State<RealtimeSearchScreen> {
  var searchName = "";

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.black,
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
                onChanged: (value) {
                  setState(() {
                    searchName = value;
                  });
                },
                style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimaryContainer), // Set text color
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
            child: searchName.isEmpty
                ? Container(
                    alignment: Alignment.center,
                    child: Text(
                      'No results found',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ) // Display nothing if searchName is empty
                : StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('anime')
                        .orderBy('title')
                        .startAt([searchName]).endAt(
                            [searchName + "\uf8ff"]).snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Something went wrong'));
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(child: Text('No results found'));
                      }

                      final results = snapshot.data!.docs
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
                              genre: genres.entries
                                  .firstWhere((genItem) =>
                                      genItem.value.title == data['genre'])
                                  .value,
                              demographic: demographics.entries
                                  .firstWhere((demItem) =>
                                      demItem.value.title ==
                                      data['demographic'])
                                  .value,
                              studio: studios.entries
                                  .firstWhere((studItem) =>
                                      studItem.value.title == data['studio'])
                                  .value,
                              status: statuses.entries
                                  .firstWhere((statItem) =>
                                      statItem.value.title == data['status'])
                                  .value,
                              startDate: DateTime.parse(data[
                                  'startDate']), // Parse startDate as DateTime
                              endDate: DateTime.parse(
                                  data['endDate']), // Parse endDate as DateTime
                            );
                          })
                          .where((anime) => anime != null)
                          .toList();

                      return ListView.builder(
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          final anime = results[index];
                          return ListTile(
                            contentPadding: const EdgeInsets.all(5),
                            minVerticalPadding: 10,
                            tileColor: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
                            leading: CircleAvatar(
                              radius: 24,
                              backgroundImage: NetworkImage(
                                anime!.imageUrl,
                              ),
                            ),
                            //leading: Image.network(anime!.imageUrl, fit: BoxFit.cover),
                            title: Text(anime.title),
                            isThreeLine: true,
                            trailing: IconButton.outlined(
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                onPressed: () {
                                  //onEditRating(showRating);
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
                                  ' ${anime.status.title}',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary),
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
