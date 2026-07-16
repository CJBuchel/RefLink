import 'package:flutter/material.dart';
import 'package:ref_link/generated/api.pb.dart';
import 'package:ref_link/views/head_referee/pre_match_layout/team_block.dart';

class TeamPanel extends StatelessWidget {
  final bool isRed;
  final MatchAllianceState allianceState;
  // Mirrors the connection indicators' near/far ordering visually - blue reads 1/2/3
  // top-to-bottom, red reads 3/2/1 so the two sides face each other symmetrically.
  final bool reversed;
  const TeamPanel({
    super.key,
    required this.isRed,
    required this.allianceState,
    this.reversed = false,
  });

  @override
  Widget build(BuildContext context) {
    final blocks = [
      TeamBlock(
        isRed: isRed,
        teamNumber: allianceState.allianceTeam1State.teamNumber,
        bypassed: allianceState.allianceTeam1State.bypassed,
      ),
      TeamBlock(
        isRed: isRed,
        teamNumber: allianceState.allianceTeam2State.teamNumber,
        bypassed: allianceState.allianceTeam2State.bypassed,
      ),
      TeamBlock(
        isRed: isRed,
        teamNumber: allianceState.allianceTeam3State.teamNumber,
        bypassed: allianceState.allianceTeam3State.bypassed,
      ),
    ];

    return Expanded(
      child: Column(children: reversed ? blocks.reversed.toList() : blocks),
    );
  }
}
