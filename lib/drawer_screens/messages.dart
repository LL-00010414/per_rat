import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting
import 'package:per_rat/drawer_screens/chat_screen.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final user = FirebaseAuth.instance.currentUser!;

  Future<Map<String, dynamic>> getRecipientData(String recipientId) async {
    var recipientDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(recipientId)
        .get();
    if (recipientDoc.exists) {
      var recipientData = recipientDoc.data()!;
      return recipientData;
    } else {
      return {
        "image_url":
            "https://cdn2.iconfinder.com/data/icons/ios-7-icons/50/user_male4-1024.png",
        // Provide a default image URL
      }; // Fallback to recipientId if user document doesn't exist
    }
  }

  Future<Map<String, dynamic>> getLatestMessage(String chatId) async {
    var latestMessageDoc = await FirebaseFirestore.instance
        .collection('conversations')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();
    if (latestMessageDoc.docs.isNotEmpty) {
      var latestMessageData = latestMessageDoc.docs.first.data();
      latestMessageData['id'] = latestMessageDoc.docs.first.id;
      return latestMessageData;
    } else {
      return {"text": "", "senderId": "", "timestamp": null};
    }
  }

  String formatTimestamp(Timestamp timestamp) {
    DateTime now = DateTime.now();
    DateTime messageDate = timestamp.toDate();
    if (messageDate.year == now.year &&
        messageDate.month == now.month &&
        messageDate.day == now.day) {
      return DateFormat.Hm().format(messageDate); // Format as time
    } else {
      return DateFormat.MMMd().format(messageDate); // Format as date
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('conversations')
            .where('participants', arrayContains: user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
                child: Text(
              'No conversations found.',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Colors.grey),
            ));
          }

          final conversations = snapshot.data!.docs;

          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 15,
            ),
            child: ListView.builder(
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                var conversation = conversations[index];
                var chatId = conversation.id;
                var participants =
                    conversation['participants'] as List<dynamic>;
                var recipientId =
                    participants.firstWhere((id) => id != user.uid);

                return FutureBuilder<Map<String, dynamic>>(
                  future: Future.wait([
                    getRecipientData(recipientId),
                    getLatestMessage(chatId),
                  ]).then((values) =>
                      {'recipientData': values[0], 'latestMessage': values[1]}),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return ListTile(
                        title: const Text('Loading...'),
                      );
                    }
                    var recipientData = snapshot.data!['recipientData'];
                    var latestMessage = snapshot.data!['latestMessage'];
                    var recipientName =
                        recipientData['username'] ?? 'no username';
                    var isSender = latestMessage['senderId'] == user.uid;
                    var timestamp = latestMessage['timestamp'] as Timestamp?;

                    return Column(
                      children: [
                        ListTile(
                          title: Text(
                            recipientName,
                            // style: TextStyle(
                            //   color: isSender ? Colors.blue : Colors.black,
                            //   fontWeight:
                            //       isSender ? FontWeight.bold : FontWeight.normal,
                            // ),
                          ),
                          subtitle: Text(
                            latestMessage['text'],
                            style: TextStyle(
                              color: isSender ? Colors.blueAccent : Colors.grey,
                            ),
                          ),
                          leading: CircleAvatar(
                            radius: 28,
                            backgroundImage: NetworkImage(
                              recipientData['image_url'] ??
                                  'https://cdn2.iconfinder.com/data/icons/ios-7-icons/50/user_male4-1024.png',
                            ),
                          ),
                          trailing: timestamp != null
                              ? Text(
                                  formatTimestamp(timestamp),
                                  style: const TextStyle(color: Colors.grey),
                                )
                              : Text('...'),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                  //chatId: chatId,
                                  recipientId: recipientId,
                                ),
                              ),
                            );
                          },
                        ),
                        const Divider(),
                      ],
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// child: Column(
//   crossAxisAlignment: CrossAxisAlignment.start,
//   children: [
// Search Bar
// TextField(
//   decoration: InputDecoration(
//     hintText: 'Search',
//     prefixIcon: Icon(Icons.search),
//     border: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(25.0),
//       borderSide: BorderSide.none,
//     ),
//     filled: true,
//     fillColor: Colors.grey[200],
//     contentPadding: EdgeInsets.zero,
//   ),
// ),
//SizedBox(height: 16),
// Tabs for All and Recent
// Row(
//   mainAxisAlignment: MainAxisAlignment.start,
//   children: [
//     ElevatedButton(
//       onPressed: () {},
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10.0),
//         ),
//       ),
//       child: Text('All'),
//     ),
//     SizedBox(
//       width: 15,
//     ),
//     ElevatedButton(
//       onPressed: () {},
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10.0),
//         ),
//       ),
//       child: Text('Recent'),
//     ),
//   ],
// ),
//SizedBox(height: 16),
// List of Messages
//   Expanded(
//     child: ListView.builder(
//       itemCount: 10,
//       itemBuilder: (context, index) {
//         return MessageItem(
//           profileImage: 'https://via.placeholder.com/150',
//           username: 'User $index',
//           message: 'Message from User $index',
//           time: '${index + 1} hr',
//         );
//       },
//     ),
//   ),
// ],

class MessageItem extends StatelessWidget {
  final String profileImage;
  final String username;
  final String message;
  final String time;

  const MessageItem({
    Key? key,
    required this.profileImage,
    required this.username,
    required this.message,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundImage: NetworkImage(profileImage),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: 16),
          Text(
            time,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
