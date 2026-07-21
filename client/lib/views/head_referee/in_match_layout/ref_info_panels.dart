import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ref_link/generated/fms.pbgrpc.dart';
import 'package:ref_link/providers/head_referee_panel_provider.dart';

class RefInfoPanels extends HookConsumerWidget {
  final bool isRed;
  const RefInfoPanels({super.key, required this.isRed});

  Widget _autoSubmissionWidget(String refereeLabel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          refereeLabel,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Icon(Icons.warning, size: 40, color: Colors.amber),
      ],
    );
  }

  Widget _autoSubmissions(
    MatchPhase phase,
    RefereePanelState near,
    RefereePanelState far,
  ) {
    if (phase != MatchPhase.MATCH_PHASE_AUTO) {
      Widget nearWidget = SizedBox.shrink();
      Widget farWidget = SizedBox.shrink();

      if (!near.autoSubmitted) {
        nearWidget = _autoSubmissionWidget(isRed ? "RN:" : "BN:");
      }

      if (!far.autoSubmitted) {
        farWidget = _autoSubmissionWidget(isRed ? "RF:" : "BF:");
      }

      return Column(
        children: [Text("Auto Submissions:"), nearWidget, farWidget],
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Widget _issueChip(String refereeLabel, String issueLabel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white24, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              refereeLabel,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            issueLabel,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _issueChipsFor(RefereePanelState panel, String refereeLabel) {
    return [
      if (panel.autoIssue) _issueChip(refereeLabel, "Auto Issue"),
      if (panel.rpIssue) _issueChip(refereeLabel, "RP Issue"),
      if (panel.endgameIssue) _issueChip(refereeLabel, "Endgame Issue"),
      if (panel.discussionNeeded) _issueChip(refereeLabel, "Discussion"),
    ];
  }

  Widget _discussionIssues(RefereePanelState near, RefereePanelState far) {
    final chips = [
      ..._issueChipsFor(near, isRed ? "RN" : "BN"),
      ..._issueChipsFor(far, isRed ? "RF" : "BF"),
    ];

    if (chips.isEmpty) {
      return const SizedBox.shrink();
    }

    final allianceColor = isRed ? Colors.red : Colors.blue;

    return Container(
      margin: const EdgeInsets.all(6),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: allianceColor.withValues(alpha: 0.15),
        border: Border.all(color: allianceColor, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              "Discussion Needed",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Wrap(spacing: 4, runSpacing: 4, children: chips),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final server = ref.watch(headRefereePanelServerProvider);
    final matchPhase = server.matchPhase;

    RefereePanelState near;
    RefereePanelState far;

    if (isRed) {
      near = server.rn;
      far = server.rf;
    } else {
      near = server.bn;
      far = server.bf;
    }

    return Column(
      children: [
        Expanded(child: Center(child: _autoSubmissions(matchPhase, near, far))),
        Expanded(child: Center(child: _discussionIssues(near, far))),
      ],
    );
  }
}
