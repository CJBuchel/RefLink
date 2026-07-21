import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ref_link/generated/api.pb.dart';
import 'package:ref_link/providers/head_referee_panel_provider.dart';
import 'package:ref_link/widgets/field_action_button.dart';
import 'package:ref_link/widgets/fouls_cards/card_assignment_grid.dart';
import 'package:ref_link/widgets/fouls_cards/fouls_cards_controller.dart';

class HeadRefereeFinalizeMatchDialog extends HookConsumerWidget {
  const HeadRefereeFinalizeMatchDialog({super.key});

  static const _cornerWidth = 220.0;

  // Only the head referee's own cards are ever submitted (see fms/cheesy/sync.rs -
  // combine_match_state) - the near/far panels' card fields are just a suggestion for the
  // head referee to consider here, never sent to Cheesy Arena directly.
  //
  // Blue reads 1/2/3 top-to-bottom, red reads 3/2/1, matching CardAssignmentGrid/TeamPanel's
  // convention so this corner mirrors the actual card grid it's suggesting edits for.
  List<(MatchStationState, CardType)> _stack(
    bool isRed,
    MatchAllianceState alliance,
    MatchCards cards,
  ) {
    final entries = [
      (
        alliance.allianceTeam1State,
        isRed ? cards.redAllianceStation1 : cards.blueAllianceStation1,
      ),
      (
        alliance.allianceTeam2State,
        isRed ? cards.redAllianceStation2 : cards.blueAllianceStation2,
      ),
      (
        alliance.allianceTeam3State,
        isRed ? cards.redAllianceStation3 : cards.blueAllianceStation3,
      ),
    ];
    return isRed ? entries.reversed.toList() : entries;
  }

  // Black/white by default; flips to the suggested card's color (with black text, matching
  // the real card's own black-on-color convention) once that panel has flagged one.
  Widget _teamChip(String teamNumber, CardType card) {
    final hasCard = card != CardType.CARD_TYPE_UNSPECIFIED;
    final background = card == CardType.CARD_TYPE_RED
        ? Colors.red
        : card == CardType.CARD_TYPE_YELLOW
        ? Colors.yellow
        : Colors.black;

    return Container(
      width: 50,
      margin: const EdgeInsets.symmetric(vertical: 3),
      padding: const EdgeInsets.symmetric(vertical: 6),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white24, width: 1),
      ),
      child: Text(
        teamNumber,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: hasCard ? Colors.black : Colors.white,
        ),
      ),
    );
  }

  Widget _panelLabel(String panelLabel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        panelLabel,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w900,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _stackColumn(List<(MatchStationState, CardType)> stack) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [for (final (team, card) in stack) _teamChip(team.teamNumber, card)],
    );
  }

  // A referee's own card system lets them call a card for either alliance (see
  // FoulsCardsAssignmentView/CardAssignmentGrid) - so each corner shows both sides, blue on
  // the left and red on the right, mirroring the main card grid's layout either side of the
  // panel's own label.
  Widget _suggestionCorner(
    String panelLabel,
    RefereePanelState panel,
    MatchAllianceState redAlliance,
    MatchAllianceState blueAlliance,
  ) {
    final blueStack = _stack(false, blueAlliance, panel.matchCards);
    final redStack = _stack(true, redAlliance, panel.matchCards);
    final hasSuggestion = [
      ...blueStack,
      ...redStack,
    ].any((e) => e.$2 != CardType.CARD_TYPE_UNSPECIFIED);

    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white24, width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (hasSuggestion)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                "Discussion Needed",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _stackColumn(blueStack),
              const SizedBox(width: 6),
              _panelLabel(panelLabel),
              const SizedBox(width: 6),
              _stackColumn(redStack),
            ],
          ),
        ],
      ),
    );
  }

  Widget _commitButton(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.all(10),
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          ref.read(headRefereePanelProvider.notifier).commitAndPost();
          context.pop();
        },
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.green,
          shadowColor: Colors.black,
          side: BorderSide(color: Colors.black, width: 3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text(
          "Commit",
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final server = ref.watch(headRefereePanelServerProvider);
    // Watch our own panel state so card edits (which only update this provider) trigger a
    // rebuild - CardAssignmentGrid reads it lazily via the controller.
    ref.watch(headRefereePanelProvider);

    final controller = FoulsCardsController(
      // Fouls aren't shown on this screen - CardAssignmentGrid never calls these.
      foulCount: ({required red, required major}) => 0,
      addFoul: ({required red, required major}) {},
      removeFoul: ({required red, required major}) {},
      cardState: (station) =>
          ref.read(headRefereePanelProvider.notifier).getAllianceStationCard(station),
      setCardState: (card, station) =>
          ref.read(headRefereePanelProvider.notifier).setCardState(card, station),
    );

    return Dialog.fullscreen(
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: _cornerWidth,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _suggestionCorner(
                    "BF",
                    server.bf,
                    server.redAllianceState,
                    server.blueAllianceState,
                  ),
                  _suggestionCorner(
                    "BN",
                    server.bn,
                    server.redAllianceState,
                    server.blueAllianceState,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 400),
                          child: Column(
                            children: [
                              const FieldActionButton(),
                              _commitButton(context, ref),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: CardAssignmentGrid(
                          controller: controller,
                          redAlliance: server.redAllianceState,
                          blueAlliance: server.blueAllianceState,
                          cardFontSize: 26,
                          cardMargin: const EdgeInsets.all(6),
                          columnGap: 30,
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: IconButton(
                      iconSize: 32,
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => context.pop(),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: _cornerWidth,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _suggestionCorner(
                    "RF",
                    server.rf,
                    server.redAllianceState,
                    server.blueAllianceState,
                  ),
                  _suggestionCorner(
                    "RN",
                    server.rn,
                    server.redAllianceState,
                    server.blueAllianceState,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
