import 'package:ref_link/generated/db.pbenum.dart';
import 'package:ref_link/helpers/local_storage.dart';
import 'package:ref_link/models/panel_types.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'panel_id_provider.g.dart';

@Riverpod(keepAlive: true)
class PanelId extends _$PanelId {
  static const String _key = 'panel_id';
  static const String _defaultId = '0000';

  void setId(String id) {
    localStorage.setString(_key, id);
    state = id;
  }

  String get id => state;
  String _getStoredIp() {
    String ip = _defaultId;
    ip = localStorage.getString(_key) ?? _defaultId;
    return ip;
  }

  void clearId() {
    localStorage.remove(_key);
    state = _defaultId;
  }

  @override
  String build() {
    return _getStoredIp();
  }
}

@riverpod
String panelName(Ref ref) {
  final panelId = ref.watch(panelIdProvider);
  PanelType pt = getPanelFromString(panelId);
  switch (pt) {
    case PanelType.PANEL_TYPE_HEAD_REFEREE:
      return 'Head Referee';
    case PanelType.PANEL_TYPE_RED_NEAR:
      return 'Red Near Referee';
    case PanelType.PANEL_TYPE_RED_FAR:
      return 'Red Far Referee';
    case PanelType.PANEL_TYPE_BLUE_NEAR:
      return 'Blue Near Referee';
    case PanelType.PANEL_TYPE_BLUE_FAR:
      return 'Blue Far Referee';
    default:
      return 'N/A';
  }
}
