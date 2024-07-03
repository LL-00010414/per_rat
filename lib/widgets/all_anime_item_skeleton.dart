import 'package:flutter/material.dart';
import 'package:per_rat/components/constants.dart';
import 'package:shimmer/shimmer.dart';

Widget allAnimeItemSkeleton = Shimmer.fromColors(
  //new colors
  baseColor: baseColor,
  highlightColor: highlightColor,

  //previous colors
  // baseColor: Color.fromARGB(255, 107, 106, 99),
  // highlightColor: Colors.grey[100]!,
  child: Padding(
    padding: const EdgeInsets.only(bottom: 15),
    child: Container(
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      // child: Row(
      //   children: [
      //     Image.network(
      //       fit: BoxFit.cover,
      //       'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ2-QJauhqYAPN8jJCj63Fx3RZyeNZKNNw3q7RWOEEwjF5AvoVxQFgP7tR-NBHvb3Qmq0I&usqp=CAU',
      //     ),
      //     Column(
      //       children: [],
      //     )
      //   ],
      // ),
    ),
  ),
);

Widget allAnimeSkeleton = ListView.builder(
  itemCount: 4,
  itemBuilder: (context, index) {
    return allAnimeItemSkeleton;
  },
);
