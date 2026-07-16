import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ref_link/providers/referee_panel_provider.dart';

class RefereeFoulCounts extends HookConsumerWidget {
  const RefereeFoulCounts({super.key});

  Widget countBox({
    required bool red,
    required bool major,
    required WidgetRef ref,
  }) {
    final fouls = ref.read(refereePanelProvider).state.matchFouls;
    Color borderColor = red ? Colors.red : Colors.blue;
    int count = 0;
    if (red) {
      count = major ? fouls.redMajorFouls : fouls.redMinorFouls;
    } else {
      count = major ? fouls.blueMajorFouls : fouls.blueMinorFouls;
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 10),
      ),
      child: Center(
        child: Text(
          count.toString(),
          style: TextStyle(
            fontSize: 80,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Expanded(child: countBox(red: false, major: false, ref: ref)),
              Expanded(child: countBox(red: false, major: true, ref: ref)),
            ],
          ),
        ),

        Expanded(
          child: Column(
            children: [
              Expanded(child: countBox(red: true, major: false, ref: ref)),
              Expanded(child: countBox(red: true, major: true, ref: ref)),
            ],
          ),
        ),
      ],
    );
  }
}
