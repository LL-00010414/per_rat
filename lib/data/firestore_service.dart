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

  Future<void> uploadUserMetadata() async {
    final User user = _auth.currentUser!;
    final userDoc = _firestore.collection('users').doc(user.uid);

    final userEmail = user.email!;
    final userJoinedTime = user.metadata.creationTime!;

    try {
      final docSnapshot = await userDoc.get();

      if (docSnapshot.exists) {
        // Document exists, check if the specific fields exist
        final data = docSnapshot.data()!;
        if (data.containsKey('email') && data.containsKey('joinedTime')) {
          // Both fields exist, no need to update
          print('both fields exist');
        } else {
          // Fields do not exist, upload the data
          await userDoc.set({
            'email': userEmail,
            'joinedTime': userJoinedTime,
          }, SetOptions(merge: true));
          print('data doesnt exist, uploading...');
        }
      } else {
        // Document does not exist, create a new one
        await userDoc.set({
          'email': userEmail,
          'joinedTime': userJoinedTime,
        }, SetOptions(merge: true));
        print('data doesnt exist, creating...');
      }
    } catch (e) {
      print('Error checking or uploading user metadata: $e');
    }
  }
}
