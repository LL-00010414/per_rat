import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget homeAnimeSkeleton = Shimmer.fromColors(
  baseColor: Color.fromARGB(255, 193, 189, 166),
  highlightColor: Colors.grey[100]!,
  child: Container(
    margin: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
    ),
    height: 400,
    width: 200,
  ),
);

Widget homeSkeleton = GridView.builder(
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    childAspectRatio: 0.5,
    crossAxisSpacing: 5,
    mainAxisSpacing: 5,
  ),
  itemCount: 4,
  itemBuilder: (context, index) {
    return homeAnimeSkeleton;
  },
);
//previous method

// Widget homeAnimeSkeleton = Shimmer.fromColors(
//   baseColor: Color.fromARGB(255, 193, 189, 166),
//   highlightColor: Colors.grey[100]!,
//   child: SizedBox(
//     height: 400,
//     width: 200,
//     child: Card(
//       margin: const EdgeInsets.all(8),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(8),
//       ),
//       clipBehavior: Clip.hardEdge,
//       elevation: 2,
//       child: Container(
//         height: 350,
//         width: 200,
//         color: Colors.white,
//       ),
//     ),
//   ),
// );

// Widget homeSkeleton = GridView.builder(
//   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//     crossAxisCount: 2,
//     childAspectRatio: 0.5,
//     crossAxisSpacing: 5,
//     mainAxisSpacing: 5,
//   ),
//   itemCount: 4,
//   itemBuilder: (context, index) {
//     return homeAnimeSkeleton;
//   },
// );
