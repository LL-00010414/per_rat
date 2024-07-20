import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  NotificationsScreen({
    super.key,
  });

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('friendRequests')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
                child: Text(
              'No new notifications',
              style: TextStyle(color: Colors.amber),
            ));
          }

          final requests = snapshot.data!.docs;

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              var request = requests[index].data() as Map<String, dynamic>;
              var senderId = request['senderId'];

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(senderId)
                    .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return ListTile(
                      title: Text('Loading...'),
                    );
                  }
                  var senderData =
                      snapshot.data!.data() as Map<String, dynamic>;

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        senderData['image_url'] ??
                            'https://cdn2.iconfinder.com/data/icons/ios-7-icons/50/user_male4-1024.png',
                      ),
                    ),
                    title: Text(senderData['username'] ?? senderData['email']),
                    subtitle: Text('Friend request received'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          style: OutlinedButton.styleFrom(
                              //backgroundColor: Colors.green,
                              foregroundColor: Colors.green),
                          icon: Icon(Icons.check),
                          onPressed: () =>
                              acceptFriendRequest(context, senderId),
                        ),
                        IconButton(
                          style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red),
                          icon: Icon(Icons.close),
                          onPressed: () =>
                              rejectFriendRequest(context, senderId),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<void> acceptFriendRequest(
      BuildContext context, String senderId) async {
    var currentUserId = user.uid;

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      var userDoc =
          FirebaseFirestore.instance.collection('users').doc(currentUserId);
      var senderDoc =
          FirebaseFirestore.instance.collection('users').doc(senderId);

      transaction.update(userDoc, {
        'friends': FieldValue.arrayUnion([senderId])
      });
      transaction.update(senderDoc, {
        'friends': FieldValue.arrayUnion([currentUserId])
      });

      var requestDoc = userDoc
          .collection('friendRequests')
          .where('senderId', isEqualTo: senderId)
          .get();
      var requestSnapshot = await requestDoc;
      for (var doc in requestSnapshot.docs) {
        transaction.delete(doc.reference);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Friend request accepted.')),
    );
  }

  Future<void> rejectFriendRequest(
      BuildContext context, String senderId) async {
    var currentUserId = user.uid;

    var requestDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('friendRequests')
        .where('senderId', isEqualTo: senderId)
        .get();
    var requestSnapshot = await requestDoc;

    for (var doc in requestSnapshot.docs) {
      await doc.reference.delete();
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Friend request rejected.')),
    );
  }
}
