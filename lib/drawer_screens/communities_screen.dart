import 'package:flutter/material.dart';

class CommunitiesScreen extends StatelessWidget {
  const CommunitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Communities'),
        centerTitle: true,
      ),
      body: (Center(
        child: Text('Community',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            )),
      )),
    );
  }
}
