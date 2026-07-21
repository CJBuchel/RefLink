import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ref_link/generated/fms.pbgrpc.dart';
import 'package:ref_link/providers/head_referee_panel_provider.dart';

class HeadRefereeFieldFouls extends HookConsumerWidget {
  final bool isMajor;
  final bool isRed;

  const HeadRefereeFieldFouls({
    super.key,
    required this.isMajor,
    required this.isRed,
  });

  Widget _foulBox(int value) {
    Color color = isRed ? Colors.red : Colors.blue;
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 15),
      color: color,
      child: Text(
        value.toString(),
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _totalFoulBox(int value) {
    Color color = isRed ? Colors.red : Colors.blue;
    return Container(
      margin: EdgeInsets.all(2),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 60),
      color: color,
      child: Text(
        value.toString(),
        style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
      ),
    );
  }

  int getFoulType(RefereePanelState panelState) {
    if (isRed) {
      return isMajor
          ? panelState.matchFouls.redMajorFouls
          : panelState.matchFouls.redMinorFouls;
    } else {
      return isMajor
          ? panelState.matchFouls.blueMajorFouls
          : panelState.matchFouls.blueMinorFouls;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final server = ref.watch(headRefereePanelServerProvider);
    int hr = 0;

    if (isRed) {
      hr = isMajor
          ? server.hr.matchFouls.redMajorFouls
          : server.hr.matchFouls.redMinorFouls;
    } else {
      hr = isMajor
          ? server.hr.matchFouls.blueMajorFouls
          : server.hr.matchFouls.blueMinorFouls;
    }

    int bf = getFoulType(server.bf);
    int bn = getFoulType(server.bn);
    int rn = getFoulType(server.rn);
    int rf = getFoulType(server.rf);

    int total = hr + bf + bn + rn + rf;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // BF, TITLE, RF
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Center(child: _foulBox(bf))),
            Expanded(child: Center(child: Text(isMajor ? "MAJOR" : "MINOR"))),
            Expanded(child: Center(child: _foulBox(rf))),
          ],
        ),
        // Total
        Expanded(flex: 1, child: Center(child: _totalFoulBox(total))),
        // BN, HR, RN
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Center(child: _foulBox(bn))),
            Expanded(child: Center(child: _foulBox(hr))),
            Expanded(child: Center(child: _foulBox(rn))),
          ],
        ),
      ],
    );
  }
}
