import 'package:flutter/material.dart';

class FoulsCardsModeButtons extends StatelessWidget {
  final VoidCallback onToggleSubtraction;
  final VoidCallback onEnterCardMode;

  const FoulsCardsModeButtons({
    super.key,
    required this.onToggleSubtraction,
    required this.onEnterCardMode,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          height: 80,
          width: 250,
          child: OutlinedButton(
            onPressed: onToggleSubtraction,
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.yellow,
              shadowColor: Colors.black,
              side: BorderSide(color: Colors.black, width: 3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // square corners
              ),
            ),
            child: Text(
              "SUBTRACT?",
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 80,
          width: 250,
          child: OutlinedButton(
            onPressed: onEnterCardMode,
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.orange,
              shadowColor: Colors.black,
              side: BorderSide(color: Colors.black, width: 3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // square corners
              ),
            ),
            child: Text(
              "CARD?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
