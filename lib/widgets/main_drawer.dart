import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 32, 28, 6),
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
              Color.fromARGB(255, 159, 142, 32),
              Color.fromARGB(255, 191, 171, 38),
              Color.fromARGB(255, 223, 200, 45),
            ])),
            child: Row(
              children: [
                Icon(
                  Icons.person_rounded,
                  size: 50,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                const SizedBox(width: 15),
                Text(
                  'Username',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
