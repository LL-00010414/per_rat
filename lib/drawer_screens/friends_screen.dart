import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:per_rat/drawer_screens/chat_screen.dart';
import 'package:per_rat/screens/guest_profile.dart';

class FriendsScreen extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friends'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error loading friends.'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('No friends found.'));
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;
          var friends = userData['friends'] as List<dynamic>?;
          if (friends == null || friends.isEmpty) {
            return Center(child: Text('No friends found.'));
          }

          return ListView.builder(
            itemCount: friends.length,
            itemBuilder: (context, index) {
              var friendId = friends[index];
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(friendId)
                    .get(),
                builder: (context, friendSnapshot) {
                  if (friendSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return ListTile(title: Text('Loading...'));
                  }
                  if (friendSnapshot.hasError) {
                    return ListTile(title: Text('Error loading user.'));
                  }
                  if (!friendSnapshot.hasData || !friendSnapshot.data!.exists) {
                    return ListTile(title: Text('User not found.'));
                  }

                  var friendUserData =
                      friendSnapshot.data!.data() as Map<String, dynamic>;

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(friendUserData['image_url'] ?? ''),
                    ),
                    title: Text(
                      friendUserData['username'] ?? friendUserData['email'],
                    ),
                    subtitle: Text(friendUserData['status'] ?? 'No status'),
                    trailing: IconButton(
                      icon: Icon(Icons.message),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              //chatId: getChatId(user.uid, friendId),
                              recipientId: friendId,
                            ),
                          ),
                        );
                      },
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              GuestProfile(guestUserId: friendId),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  String getChatId(String userId1, String userId2) {
    return userId1.hashCode <= userId2.hashCode
        ? '$userId1\_$userId2'
        : '$userId2\_$userId1';
  }
}
