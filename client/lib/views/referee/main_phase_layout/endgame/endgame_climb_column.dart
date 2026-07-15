import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ref_link/generated/db.pbenum.dart';
import 'package:ref_link/models/endgame_climb_model.dart';

class RefereeEndgameClimbColumn extends HookConsumerWidget {
  final EndgameClimbStationModel initialState;
  final ValueChanged<EndgameClimbStationModel> onChange;
  const RefereeEndgameClimbColumn({
    super.key,
    required this.initialState,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Create internal state (initial value of initialState)
    final stationState = useState(initialState);

    // Watch for initialState changes (in case parent updates)
    useEffect(() {
      stationState.value = initialState;
      return null;
    }, [initialState]);

    Color allianceColor = stationState.value.isRed ? Colors.red : Colors.blue;

    bool showTeamBorder =
        stationState.value.partnerClimbState ==
        EndgameClimbState.ENDGAME_CLIMB_STATE_UNSPECIFIED;

    bool showL1Border =
        stationState.value.partnerClimbState ==
        EndgameClimbState.ENDGAME_CLIMB_STATE_LEVEL_1;

    bool showL2Border =
        stationState.value.partnerClimbState ==
        EndgameClimbState.ENDGAME_CLIMB_STATE_LEVEL_2;

    bool showL3Border =
        stationState.value.partnerClimbState ==
        EndgameClimbState.ENDGAME_CLIMB_STATE_LEVEL_3;

    bool showNothingBorder =
        stationState.value.partnerClimbState ==
        AutoClimbState.AUTO_CLIMB_STATE_NOTHING;

    Widget climbButton({
      required String text,
      required EndgameClimbState climbType,
      Color activeColor = Colors.green,
      bool showBorder = false,
    }) {
      return Container(
        margin: EdgeInsets.all(15),
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () {
            final updated = stationState.value.copyWith(climbState: climbType);

            stationState.value = updated;
            onChange(updated);
          },
          style: OutlinedButton.styleFrom(
            backgroundColor: stationState.value.climbState == climbType
                ? activeColor
                : Colors.grey.shade800,
            shadowColor: Colors.black,
            side: BorderSide(
              color: showBorder ? Colors.yellow : Colors.black,
              width: 3,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // square corners
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    List<Widget> climbLevels() {
      if (stationState.value.teamBypassed) {
        return [
          Expanded(
            flex: 2,
            child: Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
              ),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Robot",
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Bypassed",
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ];
      } else {
        return [
          climbButton(
            text: "Level 3",
            climbType: EndgameClimbState.ENDGAME_CLIMB_STATE_LEVEL_3,
            showBorder: showL3Border,
          ),
          climbButton(
            text: "Level 2",
            climbType: EndgameClimbState.ENDGAME_CLIMB_STATE_LEVEL_2,
            showBorder: showL2Border,
          ),
          climbButton(
            text: "Level 1",
            climbType: EndgameClimbState.ENDGAME_CLIMB_STATE_LEVEL_1,
            showBorder: showL1Border,
          ),
          climbButton(
            text: "Nothing",
            climbType: EndgameClimbState.ENDGAME_CLIMB_STATE_NOTHING,
            showBorder: showNothingBorder,
            activeColor: Colors.red,
          ),
        ];
      }
    }

    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: Colors.white, width: 1),
          right: BorderSide(color: Colors.white, width: 1),
          top: BorderSide(color: Colors.white, width: 2),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.all(10),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  color: showTeamBorder ? Colors.yellow : Colors.black,
                  width: 5,
                ),
                color: allianceColor,
              ),
              child: Center(
                child: Text(
                  stationState.value.teamNumber,
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: climbLevels(),
            ),
          ),
        ],
      ),
    );
  }
}
