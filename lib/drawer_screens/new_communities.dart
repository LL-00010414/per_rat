import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:per_rat/screens/guest_profile.dart';
import 'package:random_name_generator/random_name_generator.dart';

class NewCommunities extends StatefulWidget {
  const NewCommunities({super.key});

  @override
  _NewCommunitiesState createState() => _NewCommunitiesState();
}

class _NewCommunitiesState extends State<NewCommunities> {
  final TextEditingController _searchController = TextEditingController();
  final User user = FirebaseAuth.instance.currentUser!;
  List<String> friends = [];
  String searchOption = 'people';
  String searchQuery = ''; // To store the search query

  //random name generator
  var randomNames = RandomNames(Zone.us);
  var randomCommunities = RandomNames(Zone.japan);

  @override
  void initState() {
    super.initState();
    fetchFriends();
    // Add listener to search controller
    _searchController.addListener(() {
      setState(() {
        searchQuery = _searchController.text;
      });
    });
  }

  Future<void> fetchFriends() async {
    var userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (userDoc.exists && userDoc.data()!.containsKey('friends')) {
      setState(() {
        friends = List<String>.from(userDoc.data()!['friends']);
      });
    }
  }

  Future<void> sendFriendRequest(
      BuildContext context, String recipientId) async {
    var currentUserId = user.uid;
    var userDoc =
        FirebaseFirestore.instance.collection('users').doc(recipientId);

    var friendRequestsCollection = userDoc.collection('friendRequests');

    var existingRequest = await friendRequestsCollection
        .where('senderId', isEqualTo: currentUserId)
        .get();

    if (existingRequest.docs.isEmpty) {
      await friendRequestsCollection.add({
        'senderId': currentUserId,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Friend request sent.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Friend request already sent.')),
      );
    }
  }

  Widget buildPeopleList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
              child: Text(
            'No people found.',
            style: TextStyle(color: Colors.grey),
          ));
        }
        // Get the user documents and filter by username if needed
        final users = snapshot.data!.docs
            .where((doc) =>
                doc.id != user.uid &&
                !friends.contains(doc.id) &&
                _filterByQuery(doc))
            .toList();

        if (users.isEmpty) {
          return Center(
              child: Text(
            'No people found.',
            style: TextStyle(color: Colors.grey),
          ));
        }

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            var userDoc = users[index];
            var userData = userDoc.data() as Map<String, dynamic>;
            var username = userData['username'] ?? '${randomNames.name()}';
            var imageUrl = userData['image_url'] ?? '';
            var status = userData['status'] ?? 'No Status';

            if (!_searchController.text.isEmpty &&
                !username
                    .toLowerCase()
                    .contains(_searchController.text.toLowerCase())) {
              return Container();
            }

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
                  ),
                  title: Text(
                    username,
                    style: TextStyle(
                      color: Colors.white,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  subtitle: Text(
                    status,
                    style: TextStyle(color: Colors.grey),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.person_add),
                    onPressed: () => sendFriendRequest(context, userDoc.id),
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
    );
  }

  // A helper method to filter users based on the search query
  bool _filterByQuery(DocumentSnapshot doc) {
    var userData = doc.data() as Map<String, dynamic>;
    var username = userData['username'] ?? '${randomNames.name()}';

    if (searchQuery.isEmpty) {
      return true; // Return all if search query is empty
    }

    // Return true if the username contains the search query (case-insensitive)
    return username.toLowerCase().contains(searchQuery.toLowerCase());
  }

  Widget buildCommunitiesList() {
    // Replace with the appropriate Firestore collection or data source for communities
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) {
        return Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                  'https://cdn2.iconfinder.com/data/icons/ios-7-icons/50/user_male4-1024.png',
                ),
                backgroundColor: Colors.purple[100],
              ),
              title: Text(
                '${randomCommunities.name()}',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                'Community interests and hobbies',
                style: TextStyle(color: Colors.grey),
              ),
              onTap: () {
                // Navigate to community details or join community
              },
            ),
            const Divider(),
          ],
        );
      },
    );
    // return StreamBuilder<QuerySnapshot>(
    //   stream: FirebaseFirestore.instance.collection('communities').snapshots(),
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return Center(child: CircularProgressIndicator());
    //     }
    //     if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
    //       return Center(
    //           child: Text(
    //         'No communities found.',
    //         style: TextStyle(color: Colors.grey),
    //       ));
    //     }

    //     final communities = snapshot.data!.docs;

    //     return ListView.builder(
    //       itemCount: communities.length,
    //       itemBuilder: (context, index) {
    //         var communityDoc = communities[index];
    //         var communityData = communityDoc.data() as Map<String, dynamic>;
    //         var communityName = communityData['name'] ?? 'No Name';
    //         var imageUrl = communityData['image_url'] ?? '';
    //         var description = communityData['description'] ?? 'No Description';

    //         if (!_searchController.text.isEmpty &&
    //             !communityName
    //                 .toLowerCase()
    //                 .contains(_searchController.text.toLowerCase())) {
    //           return Container();
    //         }

    //         return Column(
    //           children: [
    //             ListTile(
    //               leading: CircleAvatar(
    //                 backgroundImage: imageUrl.isNotEmpty
    //                     ? NetworkImage(imageUrl)
    //                     : NetworkImage(
    //                         'https://cdn2.iconfinder.com/data/icons/ios-7-icons/50/user_male4-1024.png',
    //                       ),
    //                 backgroundColor: Colors.purple[100],
    //               ),
    //               title: Text(
    //                 communityName,
    //                 style: TextStyle(color: Colors.white),
    //               ),
    //               subtitle: Text(
    //                 description,
    //                 style: TextStyle(color: Colors.grey),
    //               ),
    //               onTap: () {
    //                 // Navigate to community details or join community
    //               },
    //             ),
    //             const Divider(),
    //           ],
    //         );
    //       },
    //     );
    //   },
    // );
  }

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
            padding: const EdgeInsets.only(
              left: 12,
              right: 12,
              top: 15,
              bottom: 5,
            ),
            child: TextField(
              style: TextStyle(color: Colors.grey),
              controller: _searchController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                filled: true,
                fillColor: Color.fromARGB(255, 39, 39, 39),
                hintText: 'Search',
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 15,
              bottom: 10,
              top: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ChoiceChip(
                  showCheckmark: false,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  selectedColor: Theme.of(context).colorScheme.inversePrimary,
                  label: Text('People'),
                  selected: searchOption == 'people',
                  onSelected: (selected) {
                    setState(() {
                      searchOption = 'people';
                    });
                  },
                ),
                SizedBox(width: 10),
                ChoiceChip(
                  showCheckmark: false,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  selectedColor: Theme.of(context).colorScheme.inversePrimary,
                  label: Text('Communities'),
                  selected: searchOption == 'communities',
                  onSelected: (selected) {
                    setState(() {
                      searchOption = 'communities';
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: searchOption == 'people'
                ? buildPeopleList()
                : buildCommunitiesList(),
          ),
        ],
      ),
    );
  }
}
