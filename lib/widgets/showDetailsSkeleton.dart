import 'package:flutter/material.dart';
import 'package:per_rat/components/constants.dart';
import 'package:shimmer/shimmer.dart';

Widget shimmerShowSkeleton() {
  return Shimmer.fromColors(
    //previous colors
    // baseColor: Color.fromARGB(255, 107, 106, 99),
    // highlightColor: Colors.grey[100]!,

    //new colors
    baseColor: baseColor,
    highlightColor: highlightColor,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 15,
        ),
        Center(
          child: ClipRRect(
            borderRadius: customBorderGeometry,
            child: Container(
              height: 310,
              width: 200,
              color: Colors.grey[700],
            ),
          ),
        ),
        SizedBox(height: 16),
        Center(
          child: ClipRRect(
            borderRadius: customBorderGeometry,
            child: Container(
              height: 30,
              width: 300,
              color: Colors.grey[700],
            ),
          ),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ClipRRect(
              borderRadius: customBorderGeometry,
              child: Container(
                height: 80,
                width: 60,
                color: Colors.grey[700],
              ),
            ),
            ClipRRect(
              borderRadius: customBorderGeometry,
              child: Container(
                height: 80,
                width: 60,
                color: Colors.grey[700],
              ),
            ),
            ClipRRect(
              borderRadius: customBorderGeometry,
              child: Container(
                height: 80,
                width: 60,
                color: Colors.grey[700],
              ),
            ),
            ClipRRect(
              borderRadius: customBorderGeometry,
              child: Container(
                height: 80,
                width: 60,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(
            left: 15,
            right: 15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                    borderRadius: customBorderGeometry,
                    child: Container(
                      height: 18,
                      width: 100,
                      color: Colors.grey[700],
                    ),
                  ),
                  ClipRRect(
                    borderRadius: customBorderGeometry,
                    child: Container(
                      height: 18,
                      width: 80,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                    borderRadius: customBorderGeometry,
                    child: Container(
                      height: 18,
                      width: 80,
                      color: Colors.grey[700],
                    ),
                  ),
                  ClipRRect(
                    borderRadius: customBorderGeometry,
                    child: Container(
                      height: 18,
                      width: 100,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                    borderRadius: customBorderGeometry,
                    child: Container(
                      height: 18,
                      width: 90,
                      color: Colors.grey[700],
                    ),
                  ),
                  ClipRRect(
                    borderRadius: customBorderGeometry,
                    child: Container(
                      height: 18,
                      width: 50,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 22),
              ClipRRect(
                borderRadius: customBorderGeometry,
                child: Container(
                  height: 38,
                  width: double.infinity,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 22),
              ClipRRect(
                borderRadius: customBorderGeometry,
                child: Container(
                  height: 32,
                  width: 150,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 16),
              ClipRRect(
                borderRadius: customBorderGeometry,
                child: Container(
                  height: 60,
                  width: double.infinity,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
