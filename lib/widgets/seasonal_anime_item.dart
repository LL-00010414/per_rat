import 'package:flutter/material.dart';

import 'package:per_rat/models/anime.dart';
import 'package:per_rat/widgets/anime_item_trait.dart';
import 'package:transparent_image/transparent_image.dart';

class SeasonalAnimeItem extends StatelessWidget {
  const SeasonalAnimeItem({
    super.key,
    required this.anime,
    required this.onPickAnime,
    required this.onEditScore,
  });

  final Anime anime;
  final void Function(Anime anime) onPickAnime;
  final void Function(Anime anime) onEditScore;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.hardEdge,
      elevation: 2,
      child: InkWell(
        onTap: () {
          onPickAnime(anime);
        },
        child: Stack(
          children: [
            FadeInImage(
              placeholder: MemoryImage(kTransparentImage),
              image: NetworkImage(anime.imageUrl),
              fit: BoxFit.cover,
              height: 400,
              width: 200,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black54,
                // padding: const EdgeInsets.symmetric(
                //   vertical: 1,
                //   horizontal: 0,
                // ),
                child: Column(
                  children: [
                    Text(
                      anime.title,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      overflow: TextOverflow.fade,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        AnimeItemTrait(
                          icon: Icons.star_border_outlined,
                          label: '${anime.score} ',
                        ),
                        const SizedBox(width: 5),
                        AnimeItemTrait(
                          icon: Icons.movie_outlined,
                          label: anime.genre.title,
                        ),
                        const SizedBox(width: 4),
                        IconButton.outlined(
                          style: OutlinedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(199, 83, 109, 254),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          onPressed: () {
                            onEditScore(anime);
                          },
                          icon: const Icon(Icons.edit_note_sharp),
                          iconSize: 20,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
