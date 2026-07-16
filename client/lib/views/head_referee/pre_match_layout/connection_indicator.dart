import 'package:flutter/material.dart';
import 'package:ref_link/colors.dart';

class ConnectionIndicator extends StatelessWidget {
  final bool connected;
  final String label;
  const ConnectionIndicator({
    super.key,
    required this.connected,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: connected ? arenaGreen : arenaRed,
            border: Border.all(color: Colors.black, width: 4),
          ),
          child: Center(
            child: connected
                ? const Icon(Icons.check, color: Colors.white, size: 40)
                : const Text(
                    "DC",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
