import 'package:flutter/material.dart';
import 'package:ref_link/colors.dart';
import 'package:ref_link/widgets/branding.dart';

class RefereePreMatchPhase extends StatelessWidget {
  const RefereePreMatchPhase({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Waiting for match...",
                style: TextStyle(
                  color: labelFaint,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: 52,
                height: 52,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  color: arenaBlue,
                ),
              ),
            ],
          ),
          BrandingLogo(),
        ],
      ),
    );
  }
}
