import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:per_rat/models/anime.dart';
import 'package:per_rat/models/show_rating.dart';
import 'package:per_rat/widgets/anime_item_trait.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeAnimeItem extends StatelessWidget {
  const HomeAnimeItem({
    super.key,
    required this.showRating,
    required this.anime,
    required this.onSelectRating,
    required this.onDeleteRating,
  });

  final ShowRating showRating;
  final Anime anime;

  final void Function(ShowRating showRating) onSelectRating;
  final void Function(ShowRating showRating) onDeleteRating;

  //final void Function(ShowRating showRating) onEditRating;
  //final void Function(Anime anime) onSelectAnime;

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
            onSelectRating(showRating);
          },
          onLongPress: () {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.question,
              animType: AnimType.bottomSlide,
              title: 'Do you want to delete your rating?',
              titleTextStyle: TextStyle(
                fontSize: 22,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              desc: 'Do you really want to delete ${anime.title} ?',
              btnCancelOnPress: () {
                Navigator.of(context).focusNode;
              },
              btnOkOnPress: () {
                onDeleteRating(showRating);
              },
              btnOkText: 'Yes',
              btnCancelText: 'No',
            ).show();
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
                          HomeAnimeItemTrait(
                              icon: Icons.star_border_outlined,
                              label: showRating.score == 0 ||
                                      showRating.score == ''
                                  ? 'N/A'
                                  : showRating.score),
                          // (double.tryParse(anime.score) == 0)
                          //     ? 'N/A'
                          //     : anime.score),
                          const SizedBox(width: 5),
                          HomeAnimeItemTrait(
                            icon: Icons.movie_outlined,
                            label: anime.genre.first,
                          ),
                          const SizedBox(width: 5),
                          HomeAnimeItemTrait(
                            icon: Icons.numbers_outlined,
                            label: (showRating.progress == 0 ||
                                    showRating.progress == '')
                                ? 'N/A'
                                : '${showRating.progress.toString()} / ${anime.totalEpisodes}',
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
