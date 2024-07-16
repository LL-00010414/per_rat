import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:per_rat/drawer_screens/chat_screen.dart';
import 'package:per_rat/screens/guest_profile.dart';

class NewCommunities extends StatefulWidget {
  const NewCommunities({super.key});

  @override
  _NewCommunitiesState createState() => _NewCommunitiesState();
}

class _NewCommunitiesState extends State<NewCommunities> {
  final TextEditingController _searchController = TextEditingController();
  final User user = FirebaseAuth.instance.currentUser!;

  // Future<String> getChatId(String recipientId) async {
  //   var chatDocs = await FirebaseFirestore.instance
  //       .collection('conversations')
  //       .where('participants', arrayContains: user.uid)
  //       .get();

  //   for (var doc in chatDocs.docs) {
  //     var participants = doc['participants'] as List<dynamic>;
  //     if (participants.contains(recipientId)) {
  //       return doc.id;
  //     }
  //   }

  //   var newChatDoc =
  //       await FirebaseFirestore.instance.collection('conversations').add({
  //     'participants': [user.uid, recipientId],
  //   });
  //   return newChatDoc.id;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Communities'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                // Handle more actions
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.menu),
                hintText: 'search communities...',
                suffixIcon: Icon(Icons.search),
                hintStyle: TextStyle(color: Color.fromARGB(255, 205, 135, 13)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No communities found.'));
                }

                final users = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    var userDoc = users[index];
                    var userData = userDoc.data() as Map<String, dynamic>;
                    //var user = users[index].data() as Map<String, dynamic>;
                    var username = userData['username'] ?? 'No Username';
                    var imageUrl = userData['image_url'] ?? '';
                    var status = userData['status'] ?? 'No Status';

                    return Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundImage: imageUrl.isNotEmpty
                                ? NetworkImage(imageUrl)
                                : NetworkImage(
                                    'https://cdn2.iconfinder.com/data/icons/ios-7-icons/50/user_male4-1024.png',
                                  ),
                            backgroundColor: Colors.purple[100],
                            child: imageUrl.isEmpty
                                ? Text(
                                    username.isNotEmpty
                                        ? username[0].toUpperCase()
                                        : '',
                                    style: TextStyle(color: Colors.purple),
                                  )
                                : null,
                          ),
                          title: Text(
                            username,
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            status,
                            style: TextStyle(color: Colors.grey),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.message),
                            onPressed: () {
                              //var chatId = await getChatId(userDoc.id);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    //chatId: chatId,
                                    recipientId: userDoc.id,
                                  ),
                                ),
                              );
                            },
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    GuestProfile(guestUserId: userDoc.id),
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
          ),
        ],
      ),
    );
  }
}
