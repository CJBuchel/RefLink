import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ref_link/generated/fms.pbenum.dart';
import 'package:ref_link/views/head_referee/in_match_layout/in_match_button_row.dart';
import 'package:ref_link/views/head_referee/in_match_layout/in_match_team_states.dart';
import 'package:ref_link/views/head_referee/in_match_layout/match_fouls_info/match_fouls_info.dart';
import 'package:ref_link/views/head_referee/in_match_layout/ref_info_panels.dart';
import 'package:ref_link/views/head_referee/in_match_layout/referee_status.dart';

class HeadRefereeInMatchPhase extends HookConsumerWidget {
  final MatchPhase phase;
  const HeadRefereeInMatchPhase({super.key, required this.phase});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Expanded(flex: 1, child: RefereeStatusStatesWidget(phase: phase)),
        Expanded(flex: 1, child: HeadRefereeInMatchButtonRow(phase: phase)),
        Expanded(flex: 2, child: HeadRefereeMatchFoulsInfo()),
        Expanded(
          flex: 4,
          child: Row(
            children: [
              Expanded(flex: 1, child: RefInfoPanels(isRed: false)),
              Expanded(flex: 2, child: HeadRefereeInMatchTeamStates()),
              Expanded(flex: 1, child: RefInfoPanels(isRed: true)),
            ],
          ),
        ),
      ],
    );
  }
}
