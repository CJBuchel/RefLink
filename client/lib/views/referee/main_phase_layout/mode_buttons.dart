import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ref_link/providers/referee_panel_provider.dart';

class RefereeModeButtons extends HookConsumerWidget {
  const RefereeModeButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          height: 80,
          width: 250,
          child: OutlinedButton(
            onPressed: () => ref
                .read(refereeSubtractionModeProvider.notifier)
                .toggleSubtractionMode(),
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
            onPressed: () =>
                ref.read(refereeCardModeProvider.notifier).setCardMode(true),
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
