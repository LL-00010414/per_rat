import 'package:flutter/material.dart';
import 'package:per_rat/models/demographics.dart';
import 'package:per_rat/models/genres.dart';
import 'package:per_rat/models/statuses.dart';
import 'package:per_rat/models/studios.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

// class Item {
//   Item({
//     required this.id,
//   });

//   final String id;
// }

class Anime {
  Anime({
    required this.title,
    required this.imageUrl,
    required this.synopsis,
    required this.totalEpisodes,
    required this.score,
    required this.rank,
    required this.popularity,
    required this.favorites,
    required this.trailerUrl,
    required this.genre,
    required this.demographic,
    required this.studio,
    required this.status,
    required this.dateTimeRange,
  }) : id = uuid.v4();

  final String id;
  final String title;
  final String imageUrl;
  final List<String> synopsis;
  final int totalEpisodes;
  final String score;
  final String rank;
  final String popularity;
  final int favorites;
  final String trailerUrl;
  final Genre genre;
  final Demographic demographic;
  final Studio studio;
  final Status status;
  final DateTimeRange dateTimeRange;
}
