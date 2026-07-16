import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ref_link/generated/common.pbenum.dart';
import 'package:ref_link/generated/fms.pbgrpc.dart';
import 'package:ref_link/providers/fms_provider.dart';
import 'package:ref_link/providers/head_referee_panel_provider.dart';
import 'package:ref_link/views/head_referee/pre_match_layout/field_action_button.dart';
import 'package:ref_link/views/head_referee/pre_match_layout/relevant_info_panel.dart';
import 'package:ref_link/views/head_referee/pre_match_layout/two_minute_warning_button.dart';

class HeadRefereePreMatchIO extends HookConsumerWidget {
  const HeadRefereePreMatchIO({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Ticks once a second so the countdown below redraws without waiting on a new server
    // message - the deadline itself is server-provided (see FmsMatchInfo), so every client
    // counts down to the same shared instant regardless of when it last heard from the server.
    final now = useState(DateTime.now());
    useEffect(() {
      final timer = Timer.periodic(const Duration(seconds: 1), (_) {
        now.value = DateTime.now();
      });
      return timer.cancel;
    }, const []);

    final matchInfo = ref.watch(arenaMatchInfoProvider).value;
    final serverState = ref.watch(headRefereePanelServerProvider);

    final estimatedAtSec = matchInfo?.nextMatchEstimatedAtUnixSec.toInt() ?? 0;
    final hasEstimate = estimatedAtSec > 0;
    var remainingSec = 0;
    if (hasEstimate) {
      final deadline = DateTime.fromMillisecondsSinceEpoch(estimatedAtSec * 1000);
      remainingSec = deadline.difference(now.value).inSeconds;
      if (remainingSec < 0) remainingSec = 0;
    }
    // Reading fieldState back from serverState (rather than the locally-submitted state)
    // keeps the button correct across reconnects and resets it to MATCH automatically once a
    // new match's record loads. Freely toggles between Count and Reset either direction, so
    // an accidental press can be corrected.
    final fieldState = serverState.hr.fieldState;
    void onFieldActionPressed() {
      if (fieldState == FieldState.FIELD_STATE_COUNT) {
        ref.read(headRefereePanelProvider.notifier).signalFieldReset();
      } else {
        ref.read(headRefereePanelProvider.notifier).signalFieldCount();
      }
    }

    // Gated on field readiness, not the countdown: in practice a head referee can't call
    // teams onto a field that isn't reset yet, and cycle time is only a pacing estimate
    // (Cheesy Arena has no schedule-based gate either - see checkCanStartMatch). The
    // countdown below is shown purely as an ETA, not a hard requirement.
    final twoMinuteWarningApplicable = fieldState == FieldState.FIELD_STATE_RESET;
    final twoMinuteWarningExpiresAt = serverState.hr.twoMinuteWarningExpiresAtUnixSec.toInt();

    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Estimated start time",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      hasEstimate ? matchTimerLabel(remainingSec) : "--:--",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TwoMinuteWarningButton(
                  applicable: twoMinuteWarningApplicable,
                  expiresAtUnixSec: twoMinuteWarningExpiresAt,
                  onPressed: twoMinuteWarningApplicable && twoMinuteWarningExpiresAt == 0
                      ? () => ref.read(headRefereePanelProvider.notifier).giveTwoMinuteWarning()
                      : null,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: RelevantInfoPanel(
                  matchType: matchInfo?.matchType ?? MatchType.MATCH_TYPE_UNSPECIFIED,
                  fieldState: fieldState,
                ),
              ),
              Expanded(
                child: FieldActionButton(
                  state: fieldState,
                  onPressed: onFieldActionPressed,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
