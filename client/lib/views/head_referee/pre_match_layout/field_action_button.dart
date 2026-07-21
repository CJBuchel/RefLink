import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ref_link/generated/common.pbenum.dart';
import 'package:ref_link/providers/head_referee_panel_provider.dart';

class FieldActionButton extends ConsumerWidget {
  const FieldActionButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fieldState = ref.watch(headRefereePanelServerProvider).hr.fieldState;
    final isCountStage = fieldState == FieldState.FIELD_STATE_COUNT;

    void onPressed() {
      if (isCountStage) {
        ref.read(headRefereePanelProvider.notifier).signalFieldReset();
      } else {
        ref.read(headRefereePanelProvider.notifier).signalFieldCount();
      }
    }

    return Container(
      margin: const EdgeInsets.all(10),
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: isCountStage ? Colors.green : Colors.purpleAccent,
          shadowColor: Colors.black,
          side: BorderSide(color: Colors.black, width: 3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          isCountStage ? "Field Reset" : "Field Cleanup",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
