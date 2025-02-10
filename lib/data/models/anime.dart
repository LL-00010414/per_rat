import 'package:intl/intl.dart';
// import 'package:uuid/uuid.dart';

final formatter = DateFormat.yMd();
final formatterMY = DateFormat.yM();

// const uuid = Uuid();

class Anime {
  Anime({
    required this.id,
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
    required this.startDate,
    required this.endDate,
  });
  // : id = uuid.v4();

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
  final List<String> genre;
  final String demographic;
  final String studio;
  final String status;
  final DateTime startDate;
  final DateTime endDate;

  String get formattedDate {
    return formatter.format(startDate);
  }

  String get formattedDate1 {
    return formatter.format(endDate);
  }
}
