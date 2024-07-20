// import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:flutter/material.dart';
// import 'package:per_rat/models/anime.dart';
// import 'package:per_rat/models/show_rating.dart';
// import 'package:transparent_image/transparent_image.dart';

// class HomeAnimeItem extends StatelessWidget {
//   const HomeAnimeItem({
//     super.key,
//     required this.showRating,
//     required this.anime,
//     required this.onSelectRating,
//     required this.onDeleteRating,
//   });

//   final ShowRating showRating;
//   final Anime anime;

//   final void Function(ShowRating showRating) onSelectRating;
//   final void Function(ShowRating showRating) onDeleteRating;

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.all(8),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(8),
//       ),
//       clipBehavior: Clip.antiAlias,
//       elevation: 2,
//       child: InkWell(
//         onTap: () {
//           onSelectRating(showRating);
//         },
//         onLongPress: () {
//           AwesomeDialog(
//             context: context,
//             dialogType: DialogType.question,
//             animType: AnimType.bottomSlide,
//             title: 'Do you want to delete your rating?',
//             titleTextStyle: TextStyle(
//               fontSize: 22,
//               color: Theme.of(context).colorScheme.onPrimary,
//             ),
//             desc: 'Do you really want to delete ${anime.title} ?',
//             btnCancelOnPress: () {
//               Navigator.of(context).focusNode;
//             },
//             btnOkOnPress: () {
//               onDeleteRating(showRating);
//             },
//             btnOkText: 'Yes',
//             btnCancelText: 'No',
//           ).show();
//         },
//         child: Stack(
//           children: [
//             FadeInImage(
//               placeholder: MemoryImage(kTransparentImage),
//               image: NetworkImage(anime.imageUrl),
//               fit: BoxFit.cover,
//               height: 400,
//               width: double.infinity,
//             ),
//             Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     Colors.transparent,
//                     Colors.black54,
//                   ],
//                 ),
//               ),
//             ),
//             Positioned(
//               bottom: 0,
//               left: 0,
//               right: 0,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 8,
//                   horizontal: 12,
//                 ),
//                 decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(0.7),
//                   borderRadius: const BorderRadius.only(
//                     bottomLeft: Radius.circular(8),
//                     bottomRight: Radius.circular(8),
//                   ),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       anime.title,
//                       maxLines: 1,
//                       textAlign: TextAlign.center,
//                       softWrap: true,
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           children: [
//                             Icon(
//                               Icons.star,
//                               color: Colors.white,
//                               size: 16,
//                             ),
//                             const SizedBox(width: 4),
//                             Text(
//                               showRating.score.toString(),
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             Icon(
//                               Icons.numbers_outlined,
//                               color: Colors.white,
//                               size: 16,
//                             ),
//                             const SizedBox(width: 4),
//                             Text(
//                               '${showRating.progress} / ${anime.totalEpisodes}',
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       anime.genre.join(', '),
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 12,
//                         fontWeight: FontWeight.w500,
//                       ),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
