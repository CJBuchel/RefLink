import 'package:flutter/material.dart';
import 'package:ref_link/generated/api.pb.dart';
import 'package:ref_link/views/head_referee/pre_match_layout/connection_indicator.dart';

class ConnectionStatusPanel extends StatelessWidget {
  final PanelPresence presence;
  const ConnectionStatusPanel({super.key, required this.presence});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ConnectionIndicator(connected: presence.bf, label: "Blue Far"),
              ConnectionIndicator(connected: presence.bn, label: "Blue Near"),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ConnectionIndicator(connected: presence.rf, label: "Red Far"),
              ConnectionIndicator(connected: presence.rn, label: "Red Near"),
            ],
          ),
        ],
      ),
    );
  }
}
