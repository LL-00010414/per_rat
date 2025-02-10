import 'package:flutter/material.dart';
import 'package:per_rat/data/models/anime.dart';
import 'package:per_rat/data/models/show_rating.dart';

class AllAnimeItem extends StatelessWidget {
  const AllAnimeItem({
    super.key,
    required this.showRating,
    required this.anime,
    required this.onSelectRating,
    required this.onEditRating,
  });

  final ShowRating showRating;
  final Anime anime;

  final void Function(ShowRating showRating) onSelectRating;
  final void Function(ShowRating showRating) onEditRating;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          onSelectRating(showRating);
        },
        child: Container(
          color: const Color.fromARGB(255, 79, 53, 45),
          child: Row(
            children: [
              Container(
                width: 100,
                height: 140,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(anime.imageUrl),
                    // assuming imageUrl is a part of showRating
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        showRating.showName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            showRating.score.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Progress: ${showRating.progress} / ${anime.totalEpisodes}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(248, 214, 99, 33),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  onEditRating(showRating);
                },
                icon: const Icon(Icons.edit, color: Colors.white),
                tooltip: 'Edit Rating',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
