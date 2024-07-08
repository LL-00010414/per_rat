import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'chat_screen.dart';

class MessagesScreen extends StatefulWidget {
  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final user = FirebaseAuth.instance.currentUser!;

  Future<String> getRecipientName(String recipientId) async {
    var recipientDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(recipientId)
        .get();
    if (recipientDoc.exists) {
      var recipientData = recipientDoc.data()!;
      return recipientData['username'] ?? recipientData['email'];
    } else {
      return recipientId; // Fallback to recipientId if user document doesn't exist
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('conversations')
            .where('participants', arrayContains: user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No conversations found.'));
          }

          final conversations = snapshot.data!.docs;

          return ListView.builder(
            itemCount: conversations.length,
            itemBuilder: (context, index) {
              var conversation = conversations[index];
              var chatId = conversation.id;
              var participants = conversation['participants'] as List<dynamic>;
              var recipientId = participants.firstWhere((id) => id != user.uid);

              return FutureBuilder<String>(
                future: getRecipientName(recipientId),
                builder: (context, recipientSnapshot) {
                  if (!recipientSnapshot.hasData) {
                    return ListTile(
                      title: Text('Loading...'),
                    );
                  }
                  return ListTile(
                    title: Text('${recipientSnapshot.data}'),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            chatId: chatId,
                            recipientId: recipientId,
                          ),
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
}
