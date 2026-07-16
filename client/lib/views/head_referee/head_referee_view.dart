import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ref_link/generated/db.pb.dart';
import 'package:ref_link/providers/referee_panel_provider.dart';
import 'package:ref_link/views/head_referee/post_match_phase.dart';
import 'package:ref_link/views/head_referee/pre_match_layout/pre_match_phase.dart';

class HeadRefereeView extends HookConsumerWidget {
  const HeadRefereeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serverState = ref.watch(refereePanelServerProvider);

    final phase = serverState.matchPhase;

    Widget view = HeadRefereePreMatchPhase();

    switch (phase) {
      case MatchPhase.MATCH_PHASE_PRE_MATCH ||
          MatchPhase.MATCH_PHASE_IDLE_UNSPECIFIED:
        view = HeadRefereePreMatchPhase();
        break;
      case MatchPhase.MATCH_PHASE_POST_MATCH:
        view = HeadRefereePostMatchPhase();
        break;
      default:
    }

    return view;
  }
}
