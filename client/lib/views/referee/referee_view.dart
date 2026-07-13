import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ref_link/generated/api.pbgrpc.dart';
import 'package:ref_link/models/panel_types.dart';
import 'package:ref_link/providers/referee_panel_provider.dart';

class RefereeView extends HookConsumerWidget {
  final PanelType panelType;
  const RefereeView({super.key, required this.panelType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serverState = ref.watch(refereePanelServerProvider);

    return Text("Referee Screen: $panelType, phase: ${serverState.matchPhase}");
  }
}
