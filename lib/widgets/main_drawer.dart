import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:per_rat/screens/account_settings_screen.dart';
import 'package:per_rat/screens/clubs_screen.dart';
import 'package:per_rat/screens/friends_screen.dart';
import 'package:per_rat/screens/messages_screen.dart';
import 'package:per_rat/screens/notifications_screen.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({
    super.key,
    required this.onSelectScreen,
    required this.user1,
  });

  final void Function() onSelectScreen;

  final User user1;

  @override
  Widget build(BuildContext context) {
    void signUserOut() {
      GoogleSignIn().signOut();
      FirebaseAuth.instance.signOut();
      Navigator.pop(context);
    }

    return Drawer(
      backgroundColor: const Color.fromARGB(255, 32, 28, 6),
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
              Color.fromARGB(255, 94, 11, 220),
              Color.fromARGB(198, 95, 11, 220),
              Color.fromARGB(100, 95, 11, 220),
            ])),
            child: GestureDetector(
              onTap: () {
                onSelectScreen();
              },
              child: Row(
                children: [
                  Icon(
                    Icons.person_rounded,
                    size: 50,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  const SizedBox(width: 15),
                  Text(
                    user1.email!.substring(0, user1.email!.indexOf('@')),
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.people_outline_rounded,
              size: 24,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            title: Text(
              'Friends',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
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
              color: Theme.of(context).colorScheme.onBackground,
            ),
            title: Text(
              'Clubs',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
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
              color: Theme.of(context).colorScheme.onBackground,
            ),
            title: Text(
              'Messages',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
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
              color: Theme.of(context).colorScheme.onBackground,
            ),
            title: Text(
              'Notifications',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
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
              color: Theme.of(context).colorScheme.onBackground,
            ),
            title: Text(
              'Account Settings',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => const AccountSettingsScreen()));
            },
          ),
          const Divider(),
          SizedBox(
            height: 290,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Divider(),
                ListTile(
                  leading: Icon(
                    Icons.logout,
                    size: 24,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  title: Text(
                    'Logout',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                  onTap: signUserOut,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
