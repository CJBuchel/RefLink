enum PanelType { headReferee, redNear, redFar, blueNear, blueFar }

PanelType getPanelFromString(String? id) {
  switch (id) {
    case 'headReferee' || '1111':
      return PanelType.headReferee;
    case 'redNear' || '2222':
      return PanelType.redNear;
    case 'redFar' || '3333':
      return PanelType.redFar;
    case 'blueNear' || '4444':
      return PanelType.blueNear;
    case 'blueFar' || '5555':
      return PanelType.blueFar;
    default:
      throw ArgumentError('Invalid panel type: $id');
  }
}
