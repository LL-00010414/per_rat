import 'package:flutter/material.dart';

import 'package:per_rat/models/show_rating.dart';

class ShowDetailsScreen extends StatelessWidget {
  const ShowDetailsScreen({
    super.key,
    required this.showRating,
  });

  final ShowRating showRating;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(showRating.showName),
      ),
      body: Center(
        child: Text('Details for ${showRating.showName}'),
      ),
    );
  }
}
