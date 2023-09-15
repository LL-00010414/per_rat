import 'package:flutter/material.dart';

class AnimeItemTrait extends StatelessWidget {
  const AnimeItemTrait({
    super.key,
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 5,
          color: Colors.white,
        ),
        const SizedBox(
          width: 2,
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white),
        )
      ],
    );
  }
}
