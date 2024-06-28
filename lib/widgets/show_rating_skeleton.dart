// Loading shimmer effect
import 'package:flutter/material.dart';
import 'package:per_rat/components/constants.dart';
import 'package:shimmer/shimmer.dart';

Widget showRatingSkeleton = Shimmer.fromColors(
  baseColor: Color.fromARGB(255, 193, 189, 166),
  highlightColor: Colors.grey[100]!,
  child: Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: customBorderGeometry,
            child: Container(
              width: 200,
              height: 300,
              color: Colors.white,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          SizedBox(
            width: 150,
            height: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                4,
                (index) => Padding(
                  padding: const EdgeInsets.only(top: 20, right: 8),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius:
                            customBorderGeometry, // Set the desired radius here
                        child: Container(
                          width: 100,
                          height: 20,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      ClipRRect(
                        borderRadius: customBorderGeometry,
                        child: Container(
                          width: 100,
                          height: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      SizedBox(height: 20),
      ClipRRect(
        borderRadius: customBorderGeometry,
        child: Container(
          width: double.infinity,
          height: 30,
          color: Colors.white,
        ),
      ),
      SizedBox(height: 20),
      ClipRRect(
          borderRadius: customBorderGeometry,
          child: Container(
            width: 200,
            height: 30,
            color: Colors.white,
          )),
      SizedBox(height: 20),
      ClipRRect(
          borderRadius: customBorderGeometry,
          child: Container(
            width: double.infinity,
            height: 250,
            color: Colors.white,
          )),
    ],
  ),
);
