import 'package:flutter/material.dart';

class DropdownItem extends StatelessWidget {
  const DropdownItem({
    super.key,
    required this.enumTitle,
    required this.onSelectedEnum,
    required this.onChangedEnum,
    required this.dropItems,
  });
  final String enumTitle;
  final Object onSelectedEnum;
  final Function() onChangedEnum;
  final List<DropdownMenuItem<Object?>>? dropItems;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Text(
                enumTitle,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
              ),
            ),
          ],
        ),
        Expanded(
          flex: 0,
          child: DropdownButtonFormField(
              menuMaxHeight: 250,
              //style: TextStyle(color: Colors.amber),
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12))),
              //style: TextStyle(color: Colors.amber),
              padding: const EdgeInsets.only(
                top: 15,
                bottom: 15,
              ),
              value: onSelectedEnum,
              items: dropItems,
              onChanged: onChangedEnum()),
        ),
      ],
    );
  }
}
