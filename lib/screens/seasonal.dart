import 'package:flutter/material.dart';

class SeasonalScreen extends StatelessWidget {
  const SeasonalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seasonal anime'),
      ),
      body: Center(
        child: Text('Current seasonal anime...',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                )),
      ),
    );
  }
}
