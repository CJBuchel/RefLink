import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ref_link/providers/head_referee_panel_provider.dart';
import 'package:ref_link/views/head_referee/pre_match_layout/connection_status_panel.dart';
import 'package:ref_link/views/head_referee/pre_match_layout/pre_match_io.dart';
import 'package:ref_link/views/head_referee/pre_match_layout/team_panel.dart';

class HeadRefereePreMatchPhase extends HookConsumerWidget {
  const HeadRefereePreMatchPhase({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serverState = ref.watch(headRefereePanelServerProvider);

    return Column(
      children: [
        Expanded(flex: 2, child: HeadRefereePreMatchIO()),
        Expanded(
          flex: 3,
          child: Row(
            children: [
              TeamPanel(
                isRed: false,
                allianceState: serverState.blueAllianceState,
              ),
              Expanded(
                child: ConnectionStatusPanel(
                  presence: serverState.panelPresence,
                ),
              ),
              TeamPanel(
                isRed: true,
                reversed: true,
                allianceState: serverState.redAllianceState,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
