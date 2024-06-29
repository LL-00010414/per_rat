import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:per_rat/components/constants.dart';
import 'package:per_rat/drawer_screens/clubs_screen.dart';
import 'package:per_rat/drawer_screens/friends_screen.dart';
import 'package:per_rat/drawer_screens/messages_screen.dart';
import 'package:per_rat/drawer_screens/notifications_screen.dart';

import '../../user_profile_screens/account_settings_screen.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({
    super.key,
    required this.onSelectScreen,
    required this.user1,
  });

  final void Function() onSelectScreen;
  final User user1;

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  void signUserOut() {
    GoogleSignIn().signOut();
    FirebaseAuth.instance.signOut();
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String? email = widget.user1.email;

    return Drawer(
      backgroundColor: const Color.fromARGB(255, 32, 28, 6),
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 94, 11, 220),
                  Color.fromARGB(198, 95, 11, 220),
                  Color.fromARGB(100, 95, 11, 220),
                ],
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
                    return Center(
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
                        Icon(
                          Icons.person_rounded,
                          size: 50,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          getDisplayEmail(email!),
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                        ),
                      ],
                    );
                  }

                  var userData = snapshot.data!.data() as Map<String, dynamic>;

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
                        // widget.user1.email!
                        //     .substring(0, widget.user1.email!.indexOf('@')),
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                            ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          ListTile(
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
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => const FriendsScreen()));
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              Icons.nature_people,
              size: 24,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            title: Text(
              'Clubs',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => const ClubsScreen()));
            },
          ),
          const Divider(),
          ListTile(
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
                  MaterialPageRoute(builder: (ctx) => const MessagesScreen()));
            },
          ),
          const Divider(),
          ListTile(
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
          const Divider(),
          ListTile(
            leading: Icon(
              Icons.admin_panel_settings_outlined,
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
          const Divider(),
          Spacer(),
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

  // String getDisplayEmail(String email) {
  //   return email.length <= 12 ? email : email.substring(0, 12) + '...';
  // }
}
