import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ref_link/generated/api.pbgrpc.dart';
import 'package:ref_link/providers/referee_panel_provider.dart';
import 'package:ref_link/views/referee/main_phase_layout/main_phase.dart';
import 'package:ref_link/views/referee/post_match_phase.dart';
import 'package:ref_link/views/referee/pre_match_phase.dart';
import 'package:ref_link/views/referee/auto_phase_layout/auto_phase.dart';

class RefereeView extends HookConsumerWidget {
  final PanelType panelType;
  const RefereeView({super.key, required this.panelType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serverState = ref.watch(refereePanelServerProvider);
    final refereeState = ref.watch(refereePanelProvider);

    final phase = serverState.matchPhase;
    final panelState = refereeState.state;

    Widget view = RefereePreMatchPhase();

    switch (phase) {
      case MatchPhase.MATCH_PHASE_IDLE_UNSPECIFIED ||
          MatchPhase.MATCH_PHASE_PRE_MATCH:
        view = RefereePreMatchPhase();
      case MatchPhase.MATCH_PHASE_AUTO:
        view = RefereeAutoMatchPhase();
      case MatchPhase.MATCH_PHASE_TELEOP:
        if (!panelState.autoSubmitted) {
          view = RefereeAutoMatchPhase();
        } else {
          view = RefereeMainPhase();
        }
      case MatchPhase.MATCH_PHASE_ENDGAME:
        if (!panelState.autoSubmitted) {
          view = RefereeAutoMatchPhase();
        } else {
          view = RefereeMainPhase();
        }
      case MatchPhase.MATCH_PHASE_POST_MATCH:
        if (panelState.autoSubmitted && panelState.endgameSubmitted) {
          view = RefereePostMatchPhase();
        } else {
          view = RefereeMainPhase();
        }
      default:
    }

    return view;
  }
}
