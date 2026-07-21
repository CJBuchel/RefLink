import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ref_link/generated/db.pbenum.dart';
import 'package:ref_link/providers/referee_panel_provider.dart';
import 'package:ref_link/views/referee/main_phase_layout/discussion_buttons.dart';
import 'package:ref_link/views/referee/main_phase_layout/endgame/endgame_view.dart';
import 'package:ref_link/widgets/fouls_cards/fouls_cards_controller.dart';
import 'package:ref_link/widgets/fouls_cards/fouls_cards_panel.dart';

class RefereeMainPhase extends HookConsumerWidget {
  const RefereeMainPhase({super.key});

  Widget _toEndgameButton(WidgetRef ref) {
    return Positioned(
      top: 10,
      right: 10,
      child: Container(
        width: 250,
        height: 70,
        margin: EdgeInsets.all(10),
        child: OutlinedButton(
          onPressed: () =>
              ref.read(refereeEndgameModeProvider.notifier).setEndgameMode(true),
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.purpleAccent,
            shadowColor: Colors.black,
            side: BorderSide(color: Colors.black, width: 3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // square corners
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
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final refereePanelServer = ref.watch(refereePanelServerProvider);
    final endgameMode = ref.watch(refereeEndgameModeProvider);
    // Watch our own panel state so foul/card edits (which only update this provider) trigger
    // a rebuild - the fouls/cards widgets below read it lazily via the controller.
    ref.watch(refereePanelProvider);

    if (endgameMode) {
      return RefereeEndgameView();
    }

    final controller = FoulsCardsController(
      foulCount: ({required red, required major}) {
        final fouls = ref.read(refereePanelProvider).state.matchFouls;
        if (red) {
          return major ? fouls.redMajorFouls : fouls.redMinorFouls;
        }
        return major ? fouls.blueMajorFouls : fouls.blueMinorFouls;
      },
      addFoul: ({required red, required major}) => ref
          .read(refereePanelProvider.notifier)
          .addFoul(red: red, major: major),
      removeFoul: ({required red, required major}) => ref
          .read(refereePanelProvider.notifier)
          .removeFoul(red: red, major: major),
      cardState: (station) =>
          ref.read(refereePanelProvider.notifier).getAllianceStationCard(station),
      setCardState: (card, station) => ref
          .read(refereePanelProvider.notifier)
          .setCardState(card, station),
    );

    return FoulsCardsPanel(
      controller: controller,
      redAlliance: refereePanelServer.redAllianceState,
      blueAlliance: refereePanelServer.blueAllianceState,
      overlayBuilder: (context) => Stack(
        children: [
          RefereeFoulsDiscussionButtons(),
          if (refereePanelServer.matchPhase == MatchPhase.MATCH_PHASE_ENDGAME ||
              refereePanelServer.matchPhase == MatchPhase.MATCH_PHASE_POST_MATCH)
            _toEndgameButton(ref),
        ],
      ),
    );
  }
}
