import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ref_link/generated/api.pbenum.dart';
import 'package:ref_link/providers/referee_panel_provider.dart';

class _TeamCardCow extends HookConsumerWidget {
  final bool isRed;
  final String teamNumber;
  final TeamAllianceStationType allianceStation;
  const _TeamCardCow({
    required this.isRed,
    required this.teamNumber,
    required this.allianceStation,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardState = ref
        .read(refereePanelProvider.notifier)
        .getAllianceStationCard(allianceStation);

    Color cardColor = cardState == CardType.CARD_TYPE_YELLOW
        ? Colors.yellow
        : cardState == CardType.CARD_TYPE_RED
        ? Colors.red
        : Colors.green;

    Widget team = Expanded(
      flex: 1,
      child: Container(
        margin: EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 5),
          color: isRed ? Colors.red : Colors.blue,
        ),
        child: Center(
          child: Text(
            teamNumber,
            style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );

    Widget card = Expanded(
      flex: 1,
      child: Container(
        margin: EdgeInsets.all(10),
        width: double.infinity,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: cardColor,
            shadowColor: Colors.black,
            side: BorderSide(color: Colors.black, width: 3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0), // square corners
            ),
          ),

          onPressed: () {
            // go through card states
            if (cardState == CardType.CARD_TYPE_UNSPECIFIED) {
              ref
                  .read(refereePanelProvider.notifier)
                  .setCardState(CardType.CARD_TYPE_YELLOW, allianceStation);
            } else if (cardState == CardType.CARD_TYPE_YELLOW) {
              ref
                  .read(refereePanelProvider.notifier)
                  .setCardState(CardType.CARD_TYPE_RED, allianceStation);
            } else if (cardState == CardType.CARD_TYPE_RED) {
              ref
                  .read(refereePanelProvider.notifier)
                  .setCardState(
                    CardType.CARD_TYPE_UNSPECIFIED,
                    allianceStation,
                  );
            }
          },
          child: Center(
            child: cardState != CardType.CARD_TYPE_UNSPECIFIED
                ? Text(
                    "CARD",
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  )
                : null,
          ),
        ),
      ),
    );

    if (isRed) {
      return Row(children: [card, team]);
    } else {
      return Row(children: [team, card]);
    }
  }
}

class RefereeCards extends HookConsumerWidget {
  const RefereeCards({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final panelServer = ref.watch(refereePanelServerProvider);

    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            width: 250,
            margin: EdgeInsets.all(10),

            child: OutlinedButton(
              onPressed: () =>
                  ref.read(refereeCardModeProvider.notifier).setCardMode(false),
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.green,
                shadowColor: Colors.black,
                side: BorderSide(color: Colors.black, width: 3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // square corners
                ),
              ),
              child: Text(
                "Close",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: _TeamCardCow(
                        isRed: false,
                        teamNumber: panelServer
                            .blueAllianceState
                            .allianceTeam1State
                            .teamNumber,
                        allianceStation: TeamAllianceStationType
                            .TEAM_ALLIANCE_STATION_TYPE_BLUE_1,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: _TeamCardCow(
                        isRed: false,
                        teamNumber: panelServer
                            .blueAllianceState
                            .allianceTeam2State
                            .teamNumber,
                        allianceStation: TeamAllianceStationType
                            .TEAM_ALLIANCE_STATION_TYPE_BLUE_2,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: _TeamCardCow(
                        isRed: false,
                        teamNumber: panelServer
                            .blueAllianceState
                            .allianceTeam3State
                            .teamNumber,
                        allianceStation: TeamAllianceStationType
                            .TEAM_ALLIANCE_STATION_TYPE_BLUE_3,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 80),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: _TeamCardCow(
                        isRed: true,
                        teamNumber: panelServer
                            .redAllianceState
                            .allianceTeam1State
                            .teamNumber,
                        allianceStation: TeamAllianceStationType
                            .TEAM_ALLIANCE_STATION_TYPE_RED_1,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: _TeamCardCow(
                        isRed: true,
                        teamNumber: panelServer
                            .redAllianceState
                            .allianceTeam2State
                            .teamNumber,
                        allianceStation: TeamAllianceStationType
                            .TEAM_ALLIANCE_STATION_TYPE_RED_2,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: _TeamCardCow(
                        isRed: true,
                        teamNumber: panelServer
                            .redAllianceState
                            .allianceTeam3State
                            .teamNumber,
                        allianceStation: TeamAllianceStationType
                            .TEAM_ALLIANCE_STATION_TYPE_RED_3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
