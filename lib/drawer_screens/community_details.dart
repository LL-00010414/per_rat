import 'package:flutter/material.dart';

class CommunityDetails extends StatelessWidget {
  const CommunityDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Community Details'),
      ),
      body: SafeArea(
        child: Center(
          child: Text(
            'Community Details Page',
            style: TextStyle(color: theme.colorScheme.primary),
          ),
        ),
      ),
    );
  }
}
