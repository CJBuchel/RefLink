import 'package:flutter/material.dart';
import 'package:ref_link/generated/common.pbenum.dart';

// The button always shows the action for whichever state isn't currently active, so the
// head referee can freely toggle between Count and Reset (e.g. to correct an accidental
// press) rather than being locked in once Reset is signaled. "Field Cleanup" moves to COUNT
// (Cheesy's signalVolunteers - purple lights, calls volunteers in to count/cleanup);
// "Field Reset" moves to RESET (signalReset - green lights, everyone incl. teams can go on
// the field). MATCH (before either has been signaled this cycle) also shows "Field Cleanup".
class FieldActionButton extends StatelessWidget {
  final FieldState state;
  final VoidCallback? onPressed;
  const FieldActionButton({super.key, required this.state, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final isCountStage = state == FieldState.FIELD_STATE_COUNT;

    return Container(
      margin: const EdgeInsets.all(10),
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: isCountStage ? Colors.green : Colors.purpleAccent,
          shadowColor: Colors.black,
          side: BorderSide(
            color: isCountStage ? Colors.yellow : Colors.black,
            width: 3,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          isCountStage ? "Field Reset" : "Field Cleanup",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
