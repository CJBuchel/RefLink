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

    // Tracks the last partner call we've actually reacted to, so we can tell a genuine new
    // partner call apart from our own tap echoing back through `initialState` (see below).
    // Seeded as UNSPECIFIED (not the real current value) so that if the partner already has a
    // call in when this widget first mounts/reconnects, that still counts as "new" and gets
    // adopted immediately.
    final lastKnownPartnerClimb = useRef(AutoClimbState.AUTO_CLIMB_STATE_UNSPECIFIED);

    // Watch for initialState changes (in case parent updates). Auto climb is a shared,
    // continuously-synced call between the two panels (unlike endgame, which requires explicit
    // agreement before submit) - so whenever the partner's call actually changes, including a
    // correction after the fact, adopt it as our own too, not just the first time. Comparing
    // against our own current call (rather than "am I still unspecified") is what makes later
    // corrections propagate - previously this only ever fired once, while our own call was
    // still blank, which is why syncing appeared to stop working once both sides had entered
    // something (e.g. once the submit button showed up).
    useEffect(() {
      stationState.value = initialState;

      final partnerChanged = initialState.partnerClimbState != lastKnownPartnerClimb.value;
      lastKnownPartnerClimb.value = initialState.partnerClimbState;

      if (partnerChanged &&
          initialState.partnerClimbState != AutoClimbState.AUTO_CLIMB_STATE_UNSPECIFIED &&
          initialState.partnerClimbState != initialState.climbState) {
        final synced = initialState.copyWith(
          climbState: initialState.partnerClimbState,
        );
        stationState.value = synced;
        // onChange writes to a provider - deferred since useEffect callbacks run
        // synchronously during build, and Riverpod forbids modifying providers then.
        Future(() => onChange(synced));
      }

      return null;
    }, [initialState]);

    Color allianceColor = stationState.value.isRed ? Colors.red : Colors.blue;

    bool showTeamBorder =
        stationState.value.partnerClimbState ==
        AutoClimbState.AUTO_CLIMB_STATE_UNSPECIFIED;

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
                  side: BorderSide(color: Colors.black, width: 3),
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
                  side: BorderSide(color: Colors.black, width: 3),
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
