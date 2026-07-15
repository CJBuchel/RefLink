import 'package:flutter/material.dart';
import 'package:ref_link/colors.dart';

class RefereePreMatchPhase extends StatelessWidget {
  const RefereePreMatchPhase({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 52,
            height: 52,
            child: CircularProgressIndicator(strokeWidth: 4, color: arenaBlue),
          ),
          const SizedBox(height: 28),
          Text(
            "Waiting for match",
            style: TextStyle(
              color: labelFaint,
              fontSize: 22,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
