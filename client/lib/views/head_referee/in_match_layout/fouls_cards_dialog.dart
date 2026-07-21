import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ref_link/providers/head_referee_panel_provider.dart';
import 'package:ref_link/widgets/fouls_cards/fouls_cards_controller.dart';
import 'package:ref_link/widgets/fouls_cards/fouls_cards_panel.dart';

class HeadRefereeFoulsCardsDialog extends HookConsumerWidget {
  const HeadRefereeFoulsCardsDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final server = ref.watch(headRefereePanelServerProvider);
    // Watch our own panel state so foul/card edits (which only update this provider) trigger
    // a rebuild - the fouls/cards widgets below read it lazily via the controller.
    ref.watch(headRefereePanelProvider);

    final controller = FoulsCardsController(
      foulCount: ({required red, required major}) {
        final fouls = ref.read(headRefereePanelProvider).state.matchFouls;
        if (red) {
          return major ? fouls.redMajorFouls : fouls.redMinorFouls;
        }
        return major ? fouls.blueMajorFouls : fouls.blueMinorFouls;
      },
      addFoul: ({required red, required major}) => ref
          .read(headRefereePanelProvider.notifier)
          .addFoul(red: red, major: major),
      removeFoul: ({required red, required major}) => ref
          .read(headRefereePanelProvider.notifier)
          .removeFoul(red: red, major: major),
      cardState: (station) => ref
          .read(headRefereePanelProvider.notifier)
          .getAllianceStationCard(station),
      setCardState: (card, station) => ref
          .read(headRefereePanelProvider.notifier)
          .setCardState(card, station),
    );

    return Dialog.fullscreen(
      child: SafeArea(
        child: FoulsCardsPanel(
          controller: controller,
          redAlliance: server.redAllianceState,
          blueAlliance: server.blueAllianceState,
          overlayBuilder: (context) => Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: IconButton(
                iconSize: 40,
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => context.pop(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
