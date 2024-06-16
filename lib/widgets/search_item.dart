// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:per_rat/models/anime.dart';

// class SearchItem extends StatelessWidget {
//   const SearchItem({
//     super.key,
//     required this.anime,
//     required this.onPickAnime,
//     required this.result1,
//   });

//   final Anime anime;
//   final void Function(Anime anime) onPickAnime;
//   final String result1;

//   // final List<Anime> searchResult =
//   //   dummyAnime.where((a) => a.title.contains(result)).toList();

//   @override
//   Widget build(BuildContext context) {
//     var searchName = "";

//     var snapshot = FirebaseFirestore.instance
//         .collection('anime')
//         .orderBy('title')
//         .startAt([searchName]).endAt([searchName + "\uf8ff"]).snapshots();

//     return ListTile(
//       onTap: () {},
//       leading: CircleAvatar(
//         radius: 24,
//         backgroundImage: NetworkImage(snapshot['imageUrl']),
//       ),
//       title: Text(data['title']),
//       subtitle: Text(data['status']),
//     );
//   }
// }
