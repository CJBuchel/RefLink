import 'package:flutter/material.dart';
import 'package:ref_link/generated/api.pb.dart';
import 'package:ref_link/widgets/fouls_cards/fouls_cards_controller.dart';
import 'package:ref_link/widgets/fouls_cards/team_card.dart';

/// The blue/red team-card grid (cycle none -> yellow -> red -> none per station), with no
/// header of its own - reused both inside [FoulsCardsAssignmentView] (which adds a Close
/// button above it) and the head referee's finalize-match screen (which puts its own controls
/// above it instead).
class CardAssignmentGrid extends StatelessWidget {
  final FoulsCardsController controller;
  final MatchAllianceState redAlliance;
  final MatchAllianceState blueAlliance;

  /// Smaller cards for screens that share space with other content (e.g. the finalize-match
  /// screen's corner suggestion panels) rather than filling the whole screen on their own.
  final double cardFontSize;
  final EdgeInsets cardMargin;
  final double columnGap;

  const CardAssignmentGrid({
    super.key,
    required this.controller,
    required this.redAlliance,
    required this.blueAlliance,
    this.cardFontSize = 50,
    this.cardMargin = const EdgeInsets.all(10),
    this.columnGap = 80,
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

  // Blue reads 1/2/3 top-to-bottom; red reads 3/2/1, so the two sides face each other
  // symmetrically (matches TeamPanel's `reversed` convention on the pre-match screen).
  Widget _allianceColumn(bool isRed, MatchAllianceState alliance) {
    var stations = isRed ? _redStations : _blueStations;
    var teamStates = [
      alliance.allianceTeam1State,
      alliance.allianceTeam2State,
      alliance.allianceTeam3State,
    ];
    if (isRed) {
      stations = stations.reversed.toList();
      teamStates = teamStates.reversed.toList();
    }

    return Column(
      children: List.generate(3, (i) {
        return Expanded(
          child: FoulsCardsTeamCard(
            isRed: isRed,
            teamNumber: teamStates[i].teamNumber,
            cardState: controller.cardState(stations[i]),
            onCycleCard: () => _cycleCard(stations[i]),
            fontSize: cardFontSize,
            margin: cardMargin,
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 1, child: _allianceColumn(false, blueAlliance)),
        SizedBox(width: columnGap),
        Expanded(flex: 1, child: _allianceColumn(true, redAlliance)),
      ],
    );
  }
}
