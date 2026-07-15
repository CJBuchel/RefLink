import 'package:ref_link/generated/db.pbenum.dart';

PanelType getPanelFromString(String? id) {
  switch (id) {
    case 'headReferee' || '1111':
      return PanelType.PANEL_TYPE_HEAD_REFEREE;
    case 'redNear' || '2222':
      return PanelType.PANEL_TYPE_RED_NEAR;
    case 'redFar' || '3333':
      return PanelType.PANEL_TYPE_RED_FAR;
    case 'blueNear' || '4444':
      return PanelType.PANEL_TYPE_BLUE_NEAR;
    case 'blueFar' || '5555':
      return PanelType.PANEL_TYPE_BLUE_FAR;
    default:
      return PanelType.PANEL_TYPE_UNSPECIFIED;
  }
}

bool isRedPanel(PanelType panel) {
  return panel == PanelType.PANEL_TYPE_RED_NEAR ||
      panel == PanelType.PANEL_TYPE_RED_FAR;
}

bool isRedPanelFromString(String? id) {
  return isRedPanel(getPanelFromString(id));
}
