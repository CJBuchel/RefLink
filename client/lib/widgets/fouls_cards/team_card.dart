import 'package:flutter/material.dart';
import 'package:ref_link/generated/api.pbenum.dart';

class FoulsCardsTeamCard extends StatelessWidget {
  final bool isRed;
  final String teamNumber;
  final CardType cardState;
  final VoidCallback onCycleCard;

  /// Smaller when this is squeezed alongside other content (e.g. the finalize-match screen's
  /// corner suggestion panels) rather than filling the whole screen on its own.
  final double fontSize;
  final EdgeInsets margin;

  const FoulsCardsTeamCard({
    super.key,
    required this.isRed,
    required this.teamNumber,
    required this.cardState,
    required this.onCycleCard,
    this.fontSize = 50,
    this.margin = const EdgeInsets.all(10),
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
        margin: margin,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.black, width: 4),
          color: isRed ? Colors.red.shade600 : Colors.blue.shade600,
          boxShadow: const [
            BoxShadow(color: Colors.black45, blurRadius: 6, offset: Offset(0, 3)),
          ],
        ),
        child: Center(
          child: Text(
            teamNumber,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );

    Widget card = Expanded(
      flex: 1,
      child: Container(
        margin: margin,
        width: double.infinity,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: cardColor,
            shadowColor: Colors.black,
            elevation: 4,
            side: BorderSide(color: Colors.black, width: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onPressed: onCycleCard,
          child: Center(
            child: cardState != CardType.CARD_TYPE_UNSPECIFIED
                ? Text(
                    "CARD",
                    style: TextStyle(
                      fontSize: fontSize,
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
