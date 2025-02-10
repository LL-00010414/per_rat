import 'package:flutter/material.dart';

import 'package:per_rat/data/models/anime.dart';
import 'package:transparent_image/transparent_image.dart';

class SimilarAnimeItem extends StatelessWidget {
  const SimilarAnimeItem({
    super.key,
    required this.anime,
    required this.onPickAnime,
  });

  final Anime anime;
  final void Function(Anime anime) onPickAnime;

  @override
  Widget build(BuildContext context) {
    return Card(
      //margin: const EdgeInsets.all(18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 2,
      child: InkWell(
        onTap: () {
          onPickAnime(anime);
        },
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            FadeInImage(
              alignment: Alignment.center,
              placeholder: MemoryImage(kTransparentImage),
              image: NetworkImage(anime.imageUrl),
              fit: BoxFit.cover,
              // height: 150,
              // width: 120,
            ),
            Positioned(
              top: 160,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black,
                padding: const EdgeInsets.symmetric(
                  vertical: 7,
                  horizontal: 8,
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
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
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
