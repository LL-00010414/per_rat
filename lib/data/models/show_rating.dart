import 'package:cloud_firestore/cloud_firestore.dart';

class ShowRating {
  final String showName;
  final String status;
  final String progress;
  final String score;
  final Timestamp timestamp;

  ShowRating({
    required this.showName,
    required this.status,
    required this.progress,
    required this.score,
    required this.timestamp,
  });



  factory ShowRating.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return ShowRating(
      showName: doc.id,
      status: data['status'] ?? '',
      progress: data['progress'] ?? '',
      score: data['score'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }
}
