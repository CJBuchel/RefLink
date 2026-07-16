import 'package:flutter/material.dart';

class TeamBlock extends StatelessWidget {
  final bool isRed;
  final String teamNumber;
  final bool bypassed;
  const TeamBlock({
    super.key,
    required this.isRed,
    required this.teamNumber,
    this.bypassed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            color: bypassed ? Colors.orangeAccent : Colors.black,
            width: bypassed ? 6 : 5,
          ),
          color: isRed ? Colors.red : Colors.blue,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                teamNumber,
                style: const TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (bypassed)
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text(
                    "BYPASSED",
                    style: TextStyle(
                      color: Colors.orangeAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
