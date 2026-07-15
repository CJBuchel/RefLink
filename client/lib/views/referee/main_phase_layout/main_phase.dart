import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ref_link/generated/db.pbenum.dart';
import 'package:ref_link/providers/referee_panel_provider.dart';
import 'package:ref_link/views/referee/main_phase_layout/cards_view.dart';
import 'package:ref_link/views/referee/main_phase_layout/discussion_buttons.dart';
import 'package:ref_link/views/referee/main_phase_layout/endgame/endgame_view.dart';
import 'package:ref_link/views/referee/main_phase_layout/foul_buttons.dart';
import 'package:ref_link/views/referee/main_phase_layout/foul_counts.dart';
import 'package:ref_link/views/referee/main_phase_layout/mode_buttons.dart';

class RefereeMainPhase extends HookConsumerWidget {
  const RefereeMainPhase({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final refereePanelServer = ref.watch(refereePanelServerProvider);
    final cardMode = ref.watch(refereeCardModeProvider);
    final endgameMode = ref.watch(refereeEndgameModeProvider);

    if (endgameMode) {
      return RefereeEndgameView();
    } else if (cardMode) {
      return RefereeCards();
    } else {
      return Column(
        children: [
          Expanded(
            flex: 1,
            child: Stack(
              children: [
                RefereeFoulsDiscussionButtons(),
                if (refereePanelServer.matchPhase ==
                        MatchPhase.MATCH_PHASE_ENDGAME ||
                    refereePanelServer.matchPhase ==
                        MatchPhase.MATCH_PHASE_POST_MATCH)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      width: 250,
                      height: 70,
                      margin: EdgeInsets.all(10),
                      child: OutlinedButton(
                        onPressed: () => ref
                            .read(refereeEndgameModeProvider.notifier)
                            .setEndgameMode(true),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.purpleAccent,
                          shadowColor: Colors.black,
                          side: BorderSide(color: Colors.black, width: 3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              8,
                            ), // square corners
                          ),
                        ),
                        child: Text(
                          "To Endgame",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Expanded(flex: 2, child: RefereeFoulButtons(red: false)),
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(flex: 1, child: RefereeModeButtons()),
                      Expanded(
                        flex: 3,
                        child: Container(
                          margin: EdgeInsets.only(bottom: 100),
                          child: RefereeFoulCounts(),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(flex: 2, child: RefereeFoulButtons(red: true)),
              ],
            ),
          ),
        ],
      );
    }
  }
}
