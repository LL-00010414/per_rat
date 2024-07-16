import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NewCommunities extends StatefulWidget {
  @override
  _NewCommunitiesState createState() => _NewCommunitiesState();
}

class _NewCommunitiesState extends State<NewCommunities> {
  final TextEditingController _searchController = TextEditingController();

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
                    var user = users[index].data() as Map<String, dynamic>;
                    var username = user['username'] ?? 'No Username';
                    var imageUrl = user['image_url'] ?? '';
                    var status = user['status'] ?? 'No Status';

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
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
                          // Handle message button press
                        },
                      ),
                      onTap: () {
                        // Handle list tile tap
                      },
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

void main() {
  runApp(MaterialApp(
    theme: ThemeData.dark(),
    home: NewCommunities(),
  ));
}
