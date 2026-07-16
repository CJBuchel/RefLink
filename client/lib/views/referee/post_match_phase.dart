import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ref_link/colors.dart';
import 'package:ref_link/generated/api.pbgrpc.dart';
import 'package:ref_link/providers/referee_panel_provider.dart';
import 'package:ref_link/widgets/branding.dart';

class RefereePostMatchPhase extends HookConsumerWidget {
  const RefereePostMatchPhase({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentVote = ref.watch(refereePanelProvider).state.refereeVote;

    Widget voteButton(bool up) {
      Color backgroundColor = surfaceColor.shade500;

      if (up && currentVote == RefereeVote.REFEREE_VOTE_AGREE) {
        backgroundColor = Colors.green.shade800;
      } else if (!up && currentVote == RefereeVote.REFEREE_VOTE_DISAGREE) {
        backgroundColor = Colors.red.shade800;
      }

      return SizedBox(
        width: 150,
        height: 130,
        child: OutlinedButton(
          onPressed: () =>
              ref.read(refereePanelProvider.notifier).setRefereeVote(up),

          style: OutlinedButton.styleFrom(
            backgroundColor: backgroundColor,
            shadowColor: Colors.black,
            side: BorderSide(color: up ? Colors.green : Colors.red, width: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5), // square corners
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Thumb",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                up ? "Up" : "Down",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Stack(
      children: [
        Padding(
          padding: EdgeInsetsGeometry.all(30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [voteButton(true), voteButton(false)],
          ),
        ),

        BrandingLogo(),
      ],
    );
  }
}
