import 'package:flutter/material.dart';
import 'package:ref_link/generated/api.pb.dart';
import 'package:ref_link/widgets/fouls_cards/fouls_cards_controller.dart';
import 'package:ref_link/widgets/fouls_cards/team_card.dart';

class FoulsCardsAssignmentView extends StatelessWidget {
  final FoulsCardsController controller;
  final MatchAllianceState redAlliance;
  final MatchAllianceState blueAlliance;
  final VoidCallback onClose;

  const FoulsCardsAssignmentView({
    super.key,
    required this.controller,
    required this.redAlliance,
    required this.blueAlliance,
    required this.onClose,
  });

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

  void _cycleCard(TeamAllianceStationType station) {
    final current = controller.cardState(station);
    final next = current == CardType.CARD_TYPE_UNSPECIFIED
        ? CardType.CARD_TYPE_YELLOW
        : current == CardType.CARD_TYPE_YELLOW
        ? CardType.CARD_TYPE_RED
        : CardType.CARD_TYPE_UNSPECIFIED;
    controller.setCardState(next, station);
  }

  Widget _allianceColumn(bool isRed, MatchAllianceState alliance) {
    final stations = isRed ? _redStations : _blueStations;
    final teamStates = [
      alliance.allianceTeam1State,
      alliance.allianceTeam2State,
      alliance.allianceTeam3State,
    ];

    return Column(
      children: List.generate(3, (i) {
        return Expanded(
          child: FoulsCardsTeamCard(
            isRed: isRed,
            teamNumber: teamStates[i].teamNumber,
            cardState: controller.cardState(stations[i]),
            onCycleCard: () => _cycleCard(stations[i]),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            width: 250,
            margin: EdgeInsets.all(10),
            child: OutlinedButton(
              onPressed: onClose,
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
              Expanded(flex: 1, child: _allianceColumn(false, blueAlliance)),
              SizedBox(width: 80),
              Expanded(flex: 1, child: _allianceColumn(true, redAlliance)),
            ],
          ),
        ),
      ],
    );
  }
}
