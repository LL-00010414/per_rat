// import 'package:flutter/material.dart';
// import 'package:per_rat/models/anime.dart';
// import 'package:per_rat/screens/anime_details.dart';

// class MySearchDelegate extends SearchDelegate {
//   @override
//   ThemeData appBarTheme(BuildContext context) {
//     // Customize the text color here
//     final ThemeData theme1 = Theme.of(context);
//     return theme1.copyWith(
//       primaryColor:
//           Colors.blue, // Change the color of the search icon and cursor
//       textTheme: const TextTheme(
//         // Change the color of the input text
//         titleLarge: TextStyle(
//           color: Colors.amber, // Change the text color here
//         ),
//       ),
//     );
//   }

//   void pickAnime(BuildContext context, Anime anime) {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (ctx) => AnimeDetailsScreen(
//           anime: anime,
//         ),
//       ),
//     );
//   }

//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       IconButton(
//         onPressed: () {
//           if (query.isNotEmpty) {
//             query = '';
//           } else {
//             close(context, null);
//           }
//         },
//         icon: const Icon(Icons.clear_rounded),
//       ),
//     ];
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//       onPressed: () {
//         close(context, null);
//       },
//       icon: const Icon(Icons.arrow_back_ios_new_rounded),
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     Widget resultContent = const Center(
//       child: Text('No results...'),
//     );

//     List<String> matchQuery = [];
//     for (final showName in searchTerms) {
//       if (showName.toLowerCase().contains(query.toLowerCase())) {
//         matchQuery.add(showName);
//       }
//     }

//     if (matchQuery.isNotEmpty) {
//       resultContent = ListView.builder(
//         itemCount: matchQuery.length,
//         itemBuilder: (context, index) {
//           var result = matchQuery[index];
//           final List<Anime> searchResult = _DiscoverScreenState()
//               ._registeredAnime
//               .where((a) => a.title.contains(result))
//               .toList();
//           return ListTile(
//             leading: const CircleAvatar(
//               child: Text('ア'),
//             ),
//             onTap: () {
//               pickAnime(
//                 context,
//                 searchResult[index],
//               );
//             },
//             textColor: Colors.amberAccent,
//             title: Text(result),
//           );
//         },
//       );
//     }
//     return Scaffold(
//       body: resultContent,
//     );
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     List<String> matchQuery = [];
//     for (final showName in searchHistory) {
//       if (showName.toLowerCase().contains(query.toLowerCase())) {
//         matchQuery.add(showName);
//       }
//     }

//     return ListView.builder(
//       itemCount: matchQuery.length,
//       itemBuilder: (context, index) {
//         final result = matchQuery[index];

//         return ListTile(
//           leading: const CircleAvatar(
//             child: Text('ア'),
//           ),
//           onTap: () {
//             pickAnime(
//               context,
//               searchResult[index],
//             );
//           },
//           textColor: Colors.amberAccent,
//           title: Text(result),
//         );
//       },
//     );
//   }
// }
