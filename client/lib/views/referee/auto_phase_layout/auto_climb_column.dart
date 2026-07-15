import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ref_link/generated/db.pbenum.dart';
import 'package:ref_link/models/auto_climb_model.dart';

class RefereeAutoClimbColumn extends HookConsumerWidget {
  final AutoClimbStationModel initialState;
  final ValueChanged<AutoClimbStationModel> onChange;
  const RefereeAutoClimbColumn({
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
        AutoClimbState.AUTO_CLIMB_STATE_UNSPECIFIED;

    bool showL1Border =
        stationState.value.partnerClimbState ==
        AutoClimbState.AUTO_CLIMB_STATE_LEVEL_1;

    bool showNothingBorder =
        stationState.value.partnerClimbState ==
        AutoClimbState.AUTO_CLIMB_STATE_NOTHING;

    List<Widget> climbLevels() {
      if (stationState.value.teamBypassed) {
        return [
          Expanded(
            flex: 2,
            child: Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
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
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  final updated = stationState.value.copyWith(
                    climbState: AutoClimbState.AUTO_CLIMB_STATE_LEVEL_1,
                  );

                  stationState.value = updated;
                  onChange(updated);
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor:
                      stationState.value.climbState ==
                          AutoClimbState.AUTO_CLIMB_STATE_LEVEL_1
                      ? Colors.green
                      : Colors.grey.shade800,
                  shadowColor: Colors.black,
                  side: BorderSide(
                    color: showL1Border ? Colors.yellow : Colors.black,
                    width: 3,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // square corners
                  ),
                ),
                child: Text(
                  "Level 1",
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  final updated = stationState.value.copyWith(
                    climbState: AutoClimbState.AUTO_CLIMB_STATE_NOTHING,
                  );

                  stationState.value = updated;
                  onChange(updated);
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor:
                      stationState.value.climbState ==
                          AutoClimbState.AUTO_CLIMB_STATE_NOTHING
                      ? Colors.red
                      : Colors.grey.shade800,
                  shadowColor: Colors.black,
                  side: BorderSide(
                    color: showNothingBorder ? Colors.yellow : Colors.black,
                    width: 3,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // square corners
                  ),
                ),
                child: Text(
                  "Nothing",
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
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
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(10),
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
          ...climbLevels(),
        ],
      ),
    );
  }
}
