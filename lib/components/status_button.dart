import 'package:flutter/material.dart';

class StatusButton extends StatefulWidget {
  StatusButton({
    super.key,
    required this.statusColor,
    required this.status,
    required this.onPressed,
  });

  final String status;
  Color? statusColor;
  final void Function() onPressed;

  @override
  State<StatusButton> createState() => _StatusButtonState();
}

class _StatusButtonState extends State<StatusButton> {
  @override
  Widget build(BuildContext context) {
    const double buttonFontSize = 14;
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonWidth =
        screenWidth * 0.3; // Button width is 80% of the screen width
    return SizedBox(
      width: buttonWidth,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: widget.statusColor,
            //padding: const EdgeInsets.all(16.0),
            textStyle: const TextStyle(fontSize: buttonFontSize),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            )),
        onPressed: () {
          widget.onPressed;
        },
        child: Text(widget.status),
      ),
    );
  }
}
