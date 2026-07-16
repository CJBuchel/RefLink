import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ref_link/generated/api.pbgrpc.dart';
import 'package:ref_link/models/endgame_climb_model.dart';
import 'package:ref_link/models/panel_types.dart';
import 'package:ref_link/providers/panel_id_provider.dart';
import 'package:ref_link/providers/referee_panel_provider.dart';
import 'package:ref_link/views/referee/main_phase_layout/endgame/endgame_climb_column.dart';

class RefereeEndgameView extends HookConsumerWidget {
  const RefereeEndgameView({super.key});

  Widget submitEndgameButton({
    required bool canSubmit,
    required Function() onSubmit,
  }) {
    if (canSubmit) {
      return Container(
        width: 300,
        margin: EdgeInsets.all(10),

        child: OutlinedButton(
          onPressed: () => onSubmit(),
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.green,
            shadowColor: Colors.black,
            side: BorderSide(color: Colors.black, width: 3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // square corners
            ),
          ),
          child: Text(
            "Submit Endgame",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
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
            "Correct Endgame Dispute...",
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

    MatchStationState allianceStation1 = isRed
        ? refereePanelServer.redAllianceState.allianceTeam1State
        : refereePanelServer.blueAllianceState.allianceTeam1State;

    MatchStationState allianceStation2 = isRed
        ? refereePanelServer.redAllianceState.allianceTeam2State
        : refereePanelServer.blueAllianceState.allianceTeam2State;

    MatchStationState allianceStation3 = isRed
        ? refereePanelServer.redAllianceState.allianceTeam3State
        : refereePanelServer.blueAllianceState.allianceTeam3State;

    final localPanel = refereePanel.state;
    final partnerPanel = refereePanelServer.partnerPanel;

    bool canSubmit() {
      bool canSubmitStation1 = false;
      bool canSubmitStation2 = false;
      bool canSubmitStation3 = false;

      if (localPanel.endgameClimb.endgameClimbAllianceStation1 ==
              partnerPanel.endgameClimb.endgameClimbAllianceStation1 ||
          allianceStation1.bypassed) {
        canSubmitStation1 = true;
      }

      if (localPanel.endgameClimb.endgameClimbAllianceStation2 ==
              partnerPanel.endgameClimb.endgameClimbAllianceStation2 ||
          allianceStation2.bypassed) {
        canSubmitStation2 = true;
      }

      if (localPanel.endgameClimb.endgameClimbAllianceStation3 ==
              partnerPanel.endgameClimb.endgameClimbAllianceStation3 ||
          allianceStation3.bypassed) {
        canSubmitStation3 = true;
      }

      return (canSubmitStation1 && canSubmitStation2 && canSubmitStation3);
    }

    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child:
                        refereePanelServer.matchPhase ==
                            MatchPhase.MATCH_PHASE_POST_MATCH
                        ? submitEndgameButton(
                            canSubmit: canSubmit(),
                            onSubmit: () => ref
                                .read(refereePanelProvider.notifier)
                                .submitEndgame(),
                          )
                        : SizedBox(
                            width: 300,
                            height: 100,
                            child: Center(
                              child: Text(
                                "Waiting for match end...",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: 400,
                      margin: EdgeInsets.all(10),

                      child: OutlinedButton(
                        onPressed: () => ref
                            .read(refereePanelProvider.notifier)
                            .setEndgameIssue(),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: localPanel.endgameIssue
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
                          "Endgame Issue",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: RefereeEndgameClimbColumn(
                      initialState: EndgameClimbStationModel(
                        teamNumber: allianceStation1.teamNumber,
                        teamBypassed: allianceStation1.bypassed,
                        isRed: isRed,
                        climbState: localPanel.endgameClimb.endgameClimbAllianceStation1,
                        partnerClimbState:
                            partnerPanel.endgameClimb.endgameClimbAllianceStation1,
                      ),
                      onChange: (update) => ref
                          .read(refereePanelProvider.notifier)
                          .setStation1EndgameClimbState(update.climbState),
                    ),
                  ),
                  Expanded(
                    child: RefereeEndgameClimbColumn(
                      initialState: EndgameClimbStationModel(
                        teamNumber: allianceStation2.teamNumber,
                        teamBypassed: allianceStation2.bypassed,
                        isRed: isRed,
                        climbState: localPanel.endgameClimb.endgameClimbAllianceStation2,
                        partnerClimbState:
                            partnerPanel.endgameClimb.endgameClimbAllianceStation2,
                      ),
                      onChange: (update) => ref
                          .read(refereePanelProvider.notifier)
                          .setStation2EndgameClimbState(update.climbState),
                    ),
                  ),
                  Expanded(
                    child: RefereeEndgameClimbColumn(
                      initialState: EndgameClimbStationModel(
                        teamNumber: allianceStation3.teamNumber,
                        teamBypassed: allianceStation3.bypassed,
                        isRed: isRed,
                        climbState: localPanel.endgameClimb.endgameClimbAllianceStation3,
                        partnerClimbState:
                            partnerPanel.endgameClimb.endgameClimbAllianceStation3,
                      ),
                      onChange: (update) => ref
                          .read(refereePanelProvider.notifier)
                          .setStation3EndgameClimbState(update.climbState),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          right: 10,
          top: 10,
          child: Container(
            width: 300,
            height: 70,
            margin: EdgeInsets.all(10),
            child: OutlinedButton(
              onPressed: () => ref
                  .read(refereeEndgameModeProvider.notifier)
                  .setEndgameMode(false),
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.purpleAccent,
                shadowColor: Colors.black,
                side: BorderSide(color: Colors.black, width: 3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // square corners
                ),
              ),
              child: Text(
                "To Cards/Fouls",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
