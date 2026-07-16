import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ref_link/providers/fms_provider.dart';

class TwoMinuteWarningButton extends HookWidget {
  final bool applicable;
  // Unix seconds when the countdown ends (server-stamped, see arena/repository.rs) - 0 means
  // the warning hasn't been given yet this match.
  final int expiresAtUnixSec;
  final VoidCallback? onPressed;
  const TwoMinuteWarningButton({
    super.key,
    required this.applicable,
    required this.expiresAtUnixSec,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final given = expiresAtUnixSec > 0;

    // Ticks once a second while given so the countdown redraws - counts down against the
    // server-provided deadline rather than a locally-started timer, so it survives reconnects
    // and stays correct even if this widget only mounts after the warning was already given.
    final now = useState(DateTime.now());
    useEffect(() {
      if (!given) return null;
      final timer = Timer.periodic(const Duration(seconds: 1), (_) {
        now.value = DateTime.now();
      });
      return timer.cancel;
    }, [given]);

    if (given) {
      final remaining = DateTime.fromMillisecondsSinceEpoch(expiresAtUnixSec * 1000).difference(now.value);
      final remainingSec = remaining.isNegative ? 0 : remaining.inSeconds;

      return Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(10),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 3),
          color: Colors.green.shade900,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "2-Minute Warning Given",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              matchTimerLabel(remainingSec),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    if (!applicable) {
      return Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(10),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 3),
          color: Colors.yellow,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          "2-Minute Warning Unavailable",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.all(10),
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.purpleAccent,
          shadowColor: Colors.black,
          side: const BorderSide(color: Colors.black, width: 3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text(
          "Two Minute Warning",
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
