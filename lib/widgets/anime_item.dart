import 'package:flutter/material.dart';

import 'package:per_rat/models/anime.dart';
import 'package:per_rat/widgets/anime_item_trait.dart';
import 'package:transparent_image/transparent_image.dart';

class AnimeItem extends StatelessWidget {
  const AnimeItem({
    super.key,
    required this.anime,
    required this.onSelectAnime,
  });

  final Anime anime;
  final void Function(Anime anime) onSelectAnime;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.hardEdge,
      elevation: 2,
      child: Badge(
        alignment: Alignment.topRight,
        backgroundColor: Colors.amberAccent,
        largeSize: 35,
        isLabelVisible: true,
        label: const Text('new'),
        child: InkWell(
          onTap: () {
            onSelectAnime(anime);
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
                  padding: const EdgeInsets.symmetric(
                    vertical: 1,
                    horizontal: 3,
                  ),
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimeItemTrait(
                            icon: Icons.star_border_outlined,
                            label: '${anime.score} ',
                          ),
                          const SizedBox(width: 5),
                          AnimeItemTrait(
                            icon: Icons.movie_outlined,
                            label: anime.genre.name,
                          ),
                          const SizedBox(width: 5),
                          AnimeItemTrait(
                            icon: Icons.numbers_outlined,
                            label: anime.totalEpisodes.toString(),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
