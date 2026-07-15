import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ref_link/generated/api.pb.dart';
import 'package:ref_link/models/auto_climb_model.dart';
import 'package:ref_link/models/panel_types.dart';
import 'package:ref_link/providers/panel_id_provider.dart';
import 'package:ref_link/providers/referee_panel_provider.dart';
import 'package:ref_link/views/referee/auto_phase_layout/auto_climb_column.dart';

class RefereeAutoMatchPhase extends HookConsumerWidget {
  const RefereeAutoMatchPhase({super.key});

  Widget _submitButton(bool canSubmit, WidgetRef ref) {
    if (canSubmit) {
      return SizedBox(
        width: 300,
        height: 100,
        child: OutlinedButton(
          onPressed: () => ref.read(refereePanelProvider.notifier).submitAuto(),
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.green.shade800,
            shadowColor: Colors.black,
            side: BorderSide(color: Colors.black, width: 3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // square corners
            ),
          ),
          child: Text(
            "Submit Auto",
            style: TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    } else {
      return SizedBox(
        width: 300,
        height: 100,
        child: Center(
          child: Text(
            "Correct Auto Dispute...",
            style: TextStyle(
              color: Colors.red,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final refereePanelServer = ref.watch(refereePanelServerProvider);
    final refereePanel = ref.watch(refereePanelProvider);
    bool isRed = isRedPanelFromString(ref.watch(panelIdProvider));

    RefereeTeamState allianceStation1 = isRed
        ? refereePanelServer.redAllianceTeam1State
        : refereePanelServer.blueAllianceTeam1State;

    RefereeTeamState allianceStation2 = isRed
        ? refereePanelServer.redAllianceTeam2State
        : refereePanelServer.blueAllianceTeam2State;

    RefereeTeamState allianceStation3 = isRed
        ? refereePanelServer.redAllianceTeam3State
        : refereePanelServer.blueAllianceTeam3State;

    final localPanel = refereePanel.state;
    final partnerPanel = refereePanelServer.partnerPanel;

    bool canSubmit =
        localPanel.autoClimbAllianceStation1 ==
            partnerPanel.autoClimbAllianceStation1 &&
        localPanel.autoClimbAllianceStation2 ==
            partnerPanel.autoClimbAllianceStation2 &&
        localPanel.autoClimbAllianceStation3 ==
            partnerPanel.autoClimbAllianceStation3;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxHeight * 0.3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Show submit button only after auto has ended
                  if (refereePanelServer.matchPhase !=
                      MatchPhase.MATCH_PHASE_AUTO)
                    _submitButton(canSubmit, ref),
                  SizedBox(
                    width: 500,
                    height: 70,
                    child: OutlinedButton(
                      onPressed: () => ref
                          .read(refereePanelProvider.notifier)
                          .setAutoIssue(),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: localPanel.autoIssue
                            ? Colors.orange
                            : Colors.grey,
                        shadowColor: Colors.black,
                        side: BorderSide(color: Colors.black, width: 3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            8,
                          ), // square corners
                        ),
                      ),
                      child: Text(
                        "Auto Issue",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: RefereeAutoClimbColumn(
                      initialState: AutoClimbStationModel(
                        teamNumber: allianceStation1.teamNumber,
                        teamBypassed: allianceStation1.bypassed,
                        isRed: isRed,
                        climbState: localPanel.autoClimbAllianceStation1,
                        partnerClimbState:
                            partnerPanel.autoClimbAllianceStation1,
                      ),
                      onChange: (update) => ref
                          .read(refereePanelProvider.notifier)
                          .setStation1AutoClimbState(update.climbState),
                    ),
                  ),
                  Expanded(
                    child: RefereeAutoClimbColumn(
                      initialState: AutoClimbStationModel(
                        teamNumber: allianceStation2.teamNumber,
                        teamBypassed: allianceStation2.bypassed,
                        isRed: isRed,
                        climbState: localPanel.autoClimbAllianceStation2,
                        partnerClimbState:
                            partnerPanel.autoClimbAllianceStation2,
                      ),
                      onChange: (update) => ref
                          .read(refereePanelProvider.notifier)
                          .setStation2AutoClimbState(update.climbState),
                    ),
                  ),
                  Expanded(
                    child: RefereeAutoClimbColumn(
                      initialState: AutoClimbStationModel(
                        teamNumber: allianceStation3.teamNumber,
                        teamBypassed: allianceStation3.bypassed,
                        isRed: isRed,
                        climbState: localPanel.autoClimbAllianceStation3,
                        partnerClimbState:
                            partnerPanel.autoClimbAllianceStation3,
                      ),
                      onChange: (update) => ref
                          .read(refereePanelProvider.notifier)
                          .setStation3AutoClimbState(update.climbState),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
