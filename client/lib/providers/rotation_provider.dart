import 'package:ref_link/generated/db.pbenum.dart';
import 'package:ref_link/models/panel_types.dart';
import 'package:ref_link/providers/head_referee_panel_provider.dart';
import 'package:ref_link/providers/panel_id_provider.dart';
import 'package:ref_link/providers/referee_panel_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'rotation_provider.g.dart';

/// Matches remaining until rotation (0 = rotate now) - sourced from whichever server stream
/// is relevant to the currently active panel, so callers don't need to know which one to
/// watch. Callers derive whether/when to notify from this rather than a separate boolean.
@riverpod
int rotationStatus(Ref ref) {
  final panelType = getPanelFromString(ref.watch(panelIdProvider));

  if (panelType == PanelType.PANEL_TYPE_HEAD_REFEREE) {
    return ref.watch(headRefereePanelServerProvider).rotateIn;
  }

  return ref.watch(refereePanelServerProvider).rotateIn;
}
