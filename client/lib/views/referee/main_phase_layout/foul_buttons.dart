import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ref_link/providers/referee_panel_provider.dart';

class RefereeFoulButtons extends HookConsumerWidget {
  final bool red;
  const RefereeFoulButtons({super.key, required this.red});

  Widget _largeButton({required Function onPressed, required Widget child}) {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(10),
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: red ? Colors.red : Colors.blue,
          shadowColor: Colors.black,
          side: BorderSide(color: Colors.black, width: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // square corners
          ),
        ),
        onPressed: () => onPressed(),
        child: child,
      ),
    );
  }

  void updateFoul(bool subtract, bool major, WidgetRef ref) {
    if (subtract) {
      ref
          .read(refereePanelProvider.notifier)
          .removeFoul(red: red, major: major);
      // disable subtraction mode after foul removed
      ref
          .read(refereeSubtractionModeProvider.notifier)
          .setSubtractionMode(false);
    } else {
      ref.read(refereePanelProvider.notifier).addFoul(red: red, major: major);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool subtractionMode = ref.watch(refereeSubtractionModeProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: _largeButton(
            onPressed: () => updateFoul(subtractionMode, false, ref),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (subtractionMode)
                  Text(
                    "SUBTRACT",
                    style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                Text(
                  "MINOR",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "FOUL",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: _largeButton(
            onPressed: () => updateFoul(subtractionMode, true, ref),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (subtractionMode)
                  Text(
                    "SUBTRACT",
                    style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                Text(
                  "MAJOR",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "FOUL",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
