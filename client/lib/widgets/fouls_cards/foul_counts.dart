import 'package:flutter/material.dart';
import 'package:ref_link/widgets/fouls_cards/fouls_cards_controller.dart';

class FoulsCardsFoulCounts extends StatelessWidget {
  final FoulsCardsController controller;
  const FoulsCardsFoulCounts({super.key, required this.controller});

  Widget _countBox({required bool red, required bool major}) {
    final count = controller.foulCount(red: red, major: major);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: red ? Colors.red : Colors.blue, width: 10),
      ),
      child: Center(
        child: Text(
          count.toString(),
          style: const TextStyle(
            fontSize: 80,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Expanded(child: _countBox(red: false, major: false)),
              Expanded(child: _countBox(red: false, major: true)),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Expanded(child: _countBox(red: true, major: false)),
              Expanded(child: _countBox(red: true, major: true)),
            ],
          ),
        ),
      ],
    );
  }
}
