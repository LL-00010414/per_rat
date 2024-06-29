import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> setUserOnlineStatus(bool isOnline) async {
    final user = _auth.currentUser;

    if (user == null) return;

    final userDoc = _firestore.collection('users').doc(user.uid);

    if (isOnline) {
      await userDoc.set({'status': 'online'}, SetOptions(merge: true));
    } else {
      await userDoc.set({
        'status': 'offline',
        'last_online': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }
}
