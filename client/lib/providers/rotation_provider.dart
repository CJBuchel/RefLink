import 'package:ref_link/generated/db.pbenum.dart';
import 'package:ref_link/models/panel_types.dart';
import 'package:ref_link/providers/head_referee_panel_provider.dart';
import 'package:ref_link/providers/panel_id_provider.dart';
import 'package:ref_link/providers/referee_panel_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'rotation_provider.g.dart';

/// (shouldRotate, matchesUntilRotation) - sourced from whichever server stream is relevant
/// to the currently active panel, so callers don't need to know which one to watch.
@riverpod
(bool, int) rotationStatus(Ref ref) {
  final panelType = getPanelFromString(ref.watch(panelIdProvider));

  if (panelType == PanelType.PANEL_TYPE_HEAD_REFEREE) {
    final serverState = ref.watch(headRefereePanelServerProvider);
    return (serverState.rotate, serverState.rotateIn);
  }

  final serverState = ref.watch(refereePanelServerProvider);
  return (serverState.rotate, serverState.rotateIn);
}
