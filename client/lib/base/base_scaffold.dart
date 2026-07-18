import 'package:ref_link/base/app_bar.dart';
import 'package:ref_link/generated/api.pbgrpc.dart';
import 'package:ref_link/models/panel_types.dart';
import 'package:ref_link/providers/panel_id_provider.dart';
import 'package:ref_link/providers/referee_panel_provider.dart';
import 'package:ref_link/providers/rotation_provider.dart';
import 'package:ref_link/widgets/dialogs/popup_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BaseScaffold extends HookConsumerWidget {
  final GoRouterState state;
  final Widget child;
  final bool showActions;

  const BaseScaffold({
    super.key,
    required this.state,
    required this.child,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final panelType = getPanelFromString(ref.watch(panelIdProvider));

    // Fires exactly once per rotation boundary (the edge where rotate_in reaches 0), so no
    // separate "dismissed" tracking is needed - it won't reappear until the next boundary.
    ref.listen(rotationStatusProvider, (previous, next) {
      final wasRotating = previous != null && previous <= 0;
      final isRotating = next <= 0;
      if (!wasRotating && isRotating) {
        PopupDialog.warn(
          title: "Referee Rotation",
          message: const Text("Time to rotate referee positions."),
        ).show(context);
      }
    });

    // Only the four regular referee panels get this - it's a notice from the head
    // referee, not to them.
    ref.listen(refereePanelServerProvider, (previous, next) {
      if (panelType == PanelType.PANEL_TYPE_HEAD_REFEREE) return;

      final wasRequired = previous?.refReviewRequired ?? false;
      final isPostMatch = next.matchPhase == MatchPhase.MATCH_PHASE_POST_MATCH;
      if (!wasRequired && next.refReviewRequired && isPostMatch) {
        PopupDialog.warn(
          title: "Referee Review Requested",
          message: const Text("The head referee wants to review this match."),
        ).show(context);
      }
    });

    return Scaffold(
      appBar: BaseAppBar(state: state, showActions: showActions),
      body: child,
    );
  }
}
