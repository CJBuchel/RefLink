import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ref_link/colors.dart';
import 'package:ref_link/generated/api.pb.dart';
import 'package:ref_link/providers/head_referee_panel_provider.dart';
import 'package:ref_link/widgets/dialogs/popup_dialog.dart';

class HeadRefereeInMatchTeamStates extends HookConsumerWidget {
  const HeadRefereeInMatchTeamStates({super.key});

  static const _redStations = [
    TeamAllianceStationType.TEAM_ALLIANCE_STATION_TYPE_RED_1,
    TeamAllianceStationType.TEAM_ALLIANCE_STATION_TYPE_RED_2,
    TeamAllianceStationType.TEAM_ALLIANCE_STATION_TYPE_RED_3,
  ];
  static const _blueStations = [
    TeamAllianceStationType.TEAM_ALLIANCE_STATION_TYPE_BLUE_1,
    TeamAllianceStationType.TEAM_ALLIANCE_STATION_TYPE_BLUE_2,
    TeamAllianceStationType.TEAM_ALLIANCE_STATION_TYPE_BLUE_3,
  ];

  // -1 = unspecified, 0 = nothing, 1-3 = level reached.
  int _autoClimbLevel(AutoClimbState state) {
    switch (state) {
      case AutoClimbState.AUTO_CLIMB_STATE_NOTHING:
        return 0;
      case AutoClimbState.AUTO_CLIMB_STATE_LEVEL_1:
        return 1;
      default:
        return -1;
    }
  }

  int _endgameClimbLevel(EndgameClimbState state) {
    switch (state) {
      case EndgameClimbState.ENDGAME_CLIMB_STATE_NOTHING:
        return 0;
      case EndgameClimbState.ENDGAME_CLIMB_STATE_LEVEL_1:
        return 1;
      case EndgameClimbState.ENDGAME_CLIMB_STATE_LEVEL_2:
        return 2;
      case EndgameClimbState.ENDGAME_CLIMB_STATE_LEVEL_3:
        return 3;
      default:
        return -1;
    }
  }

  String _climbLabel(int level) {
    switch (level) {
      case 0:
        return "Nothing";
      case 1:
        return "Level 1";
      case 2:
        return "Level 2";
      case 3:
        return "Level 3";
      default:
        return "Unspecified";
    }
  }

  // Avoids red/blue since those are already the alliance/team colors.
  Color? _climbColor(int level) {
    switch (level) {
      case 0:
        return Colors.grey;
      case 1:
        return Colors.green.shade600;
      case 2:
        return Colors.green.shade600;
      case 3:
        return Colors.green.shade600;
      default:
        return null;
    }
  }

  Widget _rowLabel(String label) {
    return SizedBox(
      width: 80,
      child: Center(
        child: Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  Widget _infoRow(String label, List<Widget> cells, {Color? backgroundColor}) {
    return Container(
      color: backgroundColor,
      child: Row(
        children: [
          _rowLabel(label),
          ...cells.map((cell) => Expanded(child: cell)),
        ],
      ),
    );
  }

  void _showDisableDialog(
    BuildContext context,
    WidgetRef ref,
    TeamAllianceStationType station,
    MatchStationState teamState,
  ) {
    PopupDialog.error(
      title: "Disable Team",
      message: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Disable team ${teamState.teamNumber} for the rest of this match?",
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 60,
            child: OutlinedButton(
              onPressed: () {
                ref
                    .read(headRefereePanelProvider.notifier)
                    .setTeamBypass(station, true);
                context.pop();
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: supportErrorColor.shade700,
                shadowColor: Colors.black,
                side: BorderSide(color: Colors.black, width: 3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // square corners
                ),
              ),
              child: const Text(
                "DISABLE",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: const Text("Cancel"),
        ),
      ],
    ).show(context);
  }

  Widget _teamCell(
    BuildContext context,
    WidgetRef ref,
    bool isRed,
    TeamAllianceStationType station,
    MatchStationState teamState,
  ) {
    return InkWell(
      onTap: teamState.bypassed
          ? null
          : () => _showDisableDialog(context, ref, station, teamState),
      child: Container(
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isRed ? Colors.red : Colors.blue,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                teamState.teamNumber,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            if (teamState.bypassed)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    "BYPASSED",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _climbCell(int level) {
    return Container(
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: _climbColor(level),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          _climbLabel(level),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _teamRow(
    BuildContext context,
    WidgetRef ref,
    MatchAllianceState alliance,
    bool isRed,
  ) {
    final stations = isRed ? _redStations : _blueStations;
    final teamStates = [
      alliance.allianceTeam1State,
      alliance.allianceTeam2State,
      alliance.allianceTeam3State,
    ];

    return _infoRow("Team:", [
      for (var i = 0; i < 3; i++)
        _teamCell(context, ref, isRed, stations[i], teamStates[i]),
    ]);
  }

  Widget _autoRow(RefereePanelState panel) {
    final climb = panel.autoClimb;
    return _infoRow("Auto:", [
      _climbCell(_autoClimbLevel(climb.autoClimbAllianceStation1)),
      _climbCell(_autoClimbLevel(climb.autoClimbAllianceStation2)),
      _climbCell(_autoClimbLevel(climb.autoClimbAllianceStation3)),
    ], backgroundColor: Colors.white.withValues(alpha: 0.04));
  }

  Widget _endgameRow(RefereePanelState panel) {
    final climb = panel.endgameClimb;
    return _infoRow("Endgame:", [
      _climbCell(_endgameClimbLevel(climb.endgameClimbAllianceStation1)),
      _climbCell(_endgameClimbLevel(climb.endgameClimbAllianceStation2)),
      _climbCell(_endgameClimbLevel(climb.endgameClimbAllianceStation3)),
    ], backgroundColor: Colors.white.withValues(alpha: 0.09));
  }

  Widget _allianceTable(
    BuildContext context,
    WidgetRef ref,
    MatchAllianceState alliance,
    RefereePanelState nearPanel,
    bool isRed,
  ) {
    return Column(
      children: [
        Expanded(flex: 2, child: _teamRow(context, ref, alliance, isRed)),
        Expanded(flex: 1, child: _autoRow(nearPanel)),
        Expanded(flex: 1, child: _endgameRow(nearPanel)),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final server = ref.watch(headRefereePanelServerProvider);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: _allianceTable(
              context,
              ref,
              server.redAllianceState,
              server.rn,
              true,
            ),
          ),
          Expanded(
            flex: 1,
            child: _allianceTable(
              context,
              ref,
              server.blueAllianceState,
              server.bn,
              false,
            ),
          ),
        ],
      ),
    );
  }
}
