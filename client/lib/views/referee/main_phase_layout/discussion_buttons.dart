import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ref_link/providers/referee_panel_provider.dart';

class RefereeFoulsDiscussionButtons extends HookConsumerWidget {
  const RefereeFoulsDiscussionButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final refereePanel = ref.watch(refereePanelProvider);
    final localPanel = refereePanel.state;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 200,
          height: 100,
          margin: EdgeInsets.all(20),
          child: OutlinedButton(
            onPressed: () =>
                ref.read(refereePanelProvider.notifier).setRpIssue(),
            style: OutlinedButton.styleFrom(
              backgroundColor: localPanel.rpIssue ? Colors.orange : Colors.grey,
              shadowColor: Colors.black,
              side: BorderSide(color: Colors.black, width: 3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // square corners
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "RP",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Issue",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: 200,
          height: 100,
          margin: EdgeInsets.all(20),
          child: OutlinedButton(
            onPressed: () =>
                ref.read(refereePanelProvider.notifier).setDiscussionNeeded(),
            style: OutlinedButton.styleFrom(
              backgroundColor: localPanel.discussionNeeded
                  ? Colors.orange
                  : Colors.grey,
              shadowColor: Colors.black,
              side: BorderSide(color: Colors.black, width: 3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // square corners
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Discussion",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Needed",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
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
