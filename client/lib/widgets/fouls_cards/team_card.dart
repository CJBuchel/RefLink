import 'package:flutter/material.dart';
import 'package:ref_link/generated/api.pbenum.dart';

class FoulsCardsTeamCard extends StatelessWidget {
  final bool isRed;
  final String teamNumber;
  final CardType cardState;
  final VoidCallback onCycleCard;

  const FoulsCardsTeamCard({
    super.key,
    required this.isRed,
    required this.teamNumber,
    required this.cardState,
    required this.onCycleCard,
  });

  @override
  Widget build(BuildContext context) {
    Color cardColor = cardState == CardType.CARD_TYPE_YELLOW
        ? Colors.yellow
        : cardState == CardType.CARD_TYPE_RED
        ? Colors.red
        : Colors.green;

    Widget team = Expanded(
      flex: 1,
      child: Container(
        margin: EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 5),
          color: isRed ? Colors.red : Colors.blue,
        ),
        child: Center(
          child: Text(
            teamNumber,
            style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );

    Widget card = Expanded(
      flex: 1,
      child: Container(
        margin: EdgeInsets.all(10),
        width: double.infinity,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: cardColor,
            shadowColor: Colors.black,
            side: BorderSide(color: Colors.black, width: 3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0), // square corners
            ),
          ),
          onPressed: onCycleCard,
          child: Center(
            child: cardState != CardType.CARD_TYPE_UNSPECIFIED
                ? Text(
                    "CARD",
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  )
                : null,
          ),
        ),
      ),
    );

    return isRed ? Row(children: [card, team]) : Row(children: [team, card]);
  }
}
