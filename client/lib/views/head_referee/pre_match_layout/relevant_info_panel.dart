import 'package:flutter/material.dart';
import 'package:ref_link/generated/common.pbenum.dart';

// First pass at surfacing situational reminders to the head referee - bypass state now
// lives on the team blocks themselves (this panel is too small for a per-team list once you
// account for all 6 stations). Easy to extend with more once there's a source for it (e.g.
// surrogate team flags, custom per-event announcements, rankings).
class RelevantInfoPanel extends StatelessWidget {
  final MatchType matchType;
  final FieldState fieldState;
  const RelevantInfoPanel({
    super.key,
    required this.matchType,
    required this.fieldState,
  });

  @override
  Widget build(BuildContext context) {
    final lines = <Widget>[
      if (fieldState != FieldState.FIELD_STATE_RESET)
        const Text(
          "2-minute warning unavailable until the field is reset.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70, fontSize: 15),
        ),
      if (matchType == MatchType.MATCH_TYPE_PLAYOFF)
        const Text(
          "Backup robots are permitted.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
    ];

    if (lines.isEmpty) {
      return const Center(
        child: Text(
          "No alerts for this match",
          style: TextStyle(color: Colors.white38, fontSize: 16),
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final (i, line) in lines.indexed) ...[
            if (i > 0) const SizedBox(height: 8),
            line,
          ],
        ],
      ),
    );
  }
}
