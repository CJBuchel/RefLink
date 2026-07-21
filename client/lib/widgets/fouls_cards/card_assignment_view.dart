import 'package:flutter/material.dart';
import 'package:ref_link/generated/api.pb.dart';
import 'package:ref_link/widgets/fouls_cards/card_assignment_grid.dart';
import 'package:ref_link/widgets/fouls_cards/fouls_cards_controller.dart';

class FoulsCardsAssignmentView extends StatelessWidget {
  final FoulsCardsController controller;
  final MatchAllianceState redAlliance;
  final MatchAllianceState blueAlliance;
  final VoidCallback onClose;

  const FoulsCardsAssignmentView({
    super.key,
    required this.controller,
    required this.redAlliance,
    required this.blueAlliance,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            width: 250,
            margin: EdgeInsets.all(10),
            child: OutlinedButton(
              onPressed: onClose,
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.green,
                shadowColor: Colors.black,
                side: BorderSide(color: Colors.black, width: 3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // square corners
                ),
              ),
              child: Text(
                "Close",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: CardAssignmentGrid(
            controller: controller,
            redAlliance: redAlliance,
            blueAlliance: blueAlliance,
          ),
        ),
      ],
    );
  }
}
