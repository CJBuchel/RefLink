import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ref_link/generated/fms.pbgrpc.dart';
import 'package:ref_link/views/head_referee/in_match_layout/fouls_cards_dialog.dart';

class HeadRefereeInMatchButtonRow extends HookConsumerWidget {
  final MatchPhase phase;
  const HeadRefereeInMatchButtonRow({super.key, required this.phase});

  Widget _cardAndFoulsButton(BuildContext context) {
    return Flexible(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 500),
        child: OutlinedButton(
          onPressed: () => showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const HeadRefereeFoulsCardsDialog(),
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
            backgroundColor: Colors.purpleAccent,
            shadowColor: Colors.black,
            side: BorderSide(color: Colors.black, width: 3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),

          child: Text(
            "Fouls/Cards",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [_cardAndFoulsButton(context)],
    );
  }
}
