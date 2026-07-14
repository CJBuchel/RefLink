import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ref_link/generated/db.pbenum.dart';
import 'package:ref_link/models/panel_types.dart';
import 'package:ref_link/providers/panel_id_provider.dart';
import 'package:ref_link/providers/referee_panel_provider.dart';
import 'package:ref_link/utils/logger.dart';

class RefereeAutoMatchPhase extends HookConsumerWidget {
  const RefereeAutoMatchPhase({super.key});

  Widget allianceAutoClimb(
    BuildContext context,
    WidgetRef ref,
    String teamNumber,
    bool red,
    Function(AutoClimbState) onLevel1Pressed,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(10),
              width: double.infinity,
              color: red ? Colors.red : Colors.blue,
              child: Center(
                child: Text(
                  teamNumber,
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.grey.shade800,
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
            child: Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.grey.shade800,
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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final refereePanelServer = ref.watch(refereePanelServerProvider);
    final panelType = getPanelFromString(ref.watch(panelIdProvider));

    bool isRed =
        panelType == PanelType.PANEL_TYPE_RED_FAR ||
        panelType == PanelType.PANEL_TYPE_RED_NEAR;

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
                  SizedBox(
                    width: 300,
                    height: 100,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.green.shade800,
                        shadowColor: Colors.black,
                        side: BorderSide(color: Colors.black, width: 3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            8,
                          ), // square corners
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
                  ),
                  SizedBox(
                    width: 500,
                    height: 70,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.grey,
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
                    child: allianceAutoClimb(
                      context,
                      ref,
                      refereePanelServer.allianceStation1TeamNumber,
                      isRed,
                      (state) => logger.i("Station 1 changed: $state"),
                    ),
                  ),
                  Expanded(
                    child: allianceAutoClimb(
                      context,
                      ref,
                      refereePanelServer.allianceStation2TeamNumber,
                      isRed,
                      (state) => logger.i("Station 2 changed: $state"),
                    ),
                  ),
                  Expanded(
                    child: allianceAutoClimb(
                      context,
                      ref,
                      refereePanelServer.allianceStation3TeamNumber,
                      isRed,
                      (state) => logger.i("Station 3 changed: $state"),
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
