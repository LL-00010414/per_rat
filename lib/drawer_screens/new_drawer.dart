import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:per_rat/components/constants.dart';
import 'package:per_rat/data/firestore_service.dart';
import 'package:per_rat/drawer_screens/friends_screen.dart';
import 'package:per_rat/drawer_screens/messages.dart';
import 'package:per_rat/drawer_screens/new_communities.dart';
import 'package:per_rat/drawer_screens/notifications_screen.dart';
import 'package:per_rat/user_profile_screens/account_settings_screen.dart';

class NewDrawer extends StatefulWidget {
  const NewDrawer({
    super.key,
    required this.onSelectScreen,
    required this.user1,
  });

  final void Function() onSelectScreen;
  final User user1;

  @override
  State<NewDrawer> createState() => _NewDrawerState();
}

class _NewDrawerState extends State<NewDrawer> {
  final FirestoreService _firestoreService =
      FirestoreService(); // Initialize the Firestore service

  void signUserOut() {
    _firestoreService.setUserOnlineStatus(false);
    GoogleSignIn().signOut();
    FirebaseAuth.instance.signOut();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    String? email = widget.user1.email;

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 94, 11, 220),
                  Color.fromARGB(198, 95, 11, 220),
                  Color.fromARGB(100, 95, 11, 220),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: GestureDetector(
              onTap: () {
                widget.onSelectScreen();
              },
              child: FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.user1.uid)
                    .get(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return Row(
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey,
                          child: Icon(
                            Icons.person_rounded,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Text(
                          getDisplayEmail(email!),
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                      ],
                    );
                  }

                  var userData = snapshot.data!;

                  return Row(
                    children: [
                      CircleAvatar(
                          radius: 30,
                          backgroundImage: userData['image_url'] != null
                              ? NetworkImage(userData['image_url'])
                              : NetworkImage(
                                  'https://cdn2.iconfinder.com/data/icons/ios-7-icons/50/user_male4-1024.png',
                                )
                          //as ImageProvider,
                          ),
                      const SizedBox(width: 15),
                      Text(
                        getDisplayEmail(widget.user1.email!),
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: Colors.white,
                            ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(
                left: 6,
              ),
              children: [
                ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  leading: Icon(
                    Icons.people_outline_rounded,
                    size: 24,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  title: Text(
                    'Friends',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => const FriendsScreen()));
                  },
                ),
                ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  leading: Icon(
                    Icons.group,
                    size: 24,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  title: Text(
                    'Communities',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => NewCommunities()));
                  },
                ),
                ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  leading: Icon(
                    Icons.message,
                    size: 24,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  title: Text(
                    'Messages',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => MessagesScreen()));
                  },
                ),
                ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  leading: Icon(
                    Icons.notifications,
                    size: 24,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  title: Text(
                    'Notifications',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => const NotificationsScreen()));
                  },
                ),
                ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  leading: Icon(
                    Icons.settings,
                    size: 24,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  title: Text(
                    'Account Settings',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => const AccountSettingsScreen()));
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              Icons.logout,
              size: 24,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            title: Text(
              'Logout',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            onTap: signUserOut,
          ),
        ],
      ),
    );
  }
}
