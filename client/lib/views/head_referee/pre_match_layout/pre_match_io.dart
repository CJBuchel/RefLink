import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ref_link/generated/common.pbenum.dart';
import 'package:ref_link/generated/fms.pbgrpc.dart';
import 'package:ref_link/providers/fms_provider.dart';
import 'package:ref_link/providers/head_referee_panel_provider.dart';
import 'package:ref_link/views/head_referee/pre_match_layout/relevant_info_panel.dart';
import 'package:ref_link/views/head_referee/pre_match_layout/two_minute_warning_button.dart';
import 'package:ref_link/widgets/field_action_button.dart';

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
    // keeps this correct across reconnects and resets it to MATCH automatically once a new
    // match's record loads. FieldActionButton itself watches this same server state for its
    // own display/toggle logic - this copy is only needed here for RelevantInfoPanel and the
    // warning gate below.
    final fieldState = serverState.hr.fieldState;

    // Gated on the estimated start countdown (the same one shown above) rather than field
    // readiness: applicable as long as the estimated start hasn't passed yet. If there's no
    // estimate at all (e.g. first match of the event, a big gap - see CheesyEventStatus),
    // there's nothing to gate on, so allow it rather than blocking the warning.
    final twoMinuteWarningApplicable = !hasEstimate || remainingSec > 0;
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
                child: FieldActionButton(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
