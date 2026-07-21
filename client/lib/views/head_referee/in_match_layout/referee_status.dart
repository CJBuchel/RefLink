import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ref_link/generated/common.pb.dart';
import 'package:ref_link/providers/head_referee_panel_provider.dart';

class RefereeStatusStatesWidget extends HookConsumerWidget {
  final MatchPhase phase;
  const RefereeStatusStatesWidget({super.key, required this.phase});

  static const _iconSize = 40.0;

  Widget _statusIcon(RefereePanelState panel) {
    final awaitingAuto =
        phase == MatchPhase.MATCH_PHASE_TELEOP ||
        phase == MatchPhase.MATCH_PHASE_ENDGAME ||
        phase == MatchPhase.MATCH_PHASE_POST_MATCH;

    if (awaitingAuto && !panel.autoSubmitted) {
      return Icon(Icons.warning_rounded, size: _iconSize, color: Colors.amber);
    }

    if (phase == MatchPhase.MATCH_PHASE_POST_MATCH && !panel.endgameSubmitted) {
      return Icon(Icons.timer, size: _iconSize, color: Colors.blue);
    }

    if (phase == MatchPhase.MATCH_PHASE_POST_MATCH) {
      switch (panel.refereeVote) {
        case RefereeVote.REFEREE_VOTE_AGREE:
          return CircleAvatar(
            radius: _iconSize / 2,
            backgroundColor: Colors.green,
            child: Icon(Icons.thumb_up, color: Colors.white),
          );
        case RefereeVote.REFEREE_VOTE_DISAGREE:
          return CircleAvatar(
            radius: _iconSize / 2,
            backgroundColor: Colors.red,
            child: Icon(Icons.thumb_down, color: Colors.white),
          );
        default:
          return SizedBox(width: _iconSize, height: _iconSize);
      }
    }

    return Icon(Icons.timer, size: _iconSize, color: Colors.blue);
  }

  Widget _refereeStatus(PanelType type, RefereePanelState panel) {
    String referee = "N/A";

    switch (type) {
      case PanelType.PANEL_TYPE_BLUE_FAR:
        referee = "BF";
        break;
      case PanelType.PANEL_TYPE_BLUE_NEAR:
        referee = "BN";
        break;
      case PanelType.PANEL_TYPE_RED_NEAR:
        referee = "RN";
        break;
      case PanelType.PANEL_TYPE_RED_FAR:
        referee = "RF";
        break;
      default:
        referee = "N/A";
        break;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          referee,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        _statusIcon(panel),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serverState = ref.watch(headRefereePanelServerProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _refereeStatus(PanelType.PANEL_TYPE_BLUE_FAR, serverState.bf),
        _refereeStatus(PanelType.PANEL_TYPE_BLUE_NEAR, serverState.bn),
        _refereeStatus(PanelType.PANEL_TYPE_RED_NEAR, serverState.rn),
        _refereeStatus(PanelType.PANEL_TYPE_RED_FAR, serverState.rf),
      ],
    );
  }
}
