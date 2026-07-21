import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ref_link/views/head_referee/in_match_layout/match_fouls_info/field_fouls_widget.dart';

class HeadRefereeMatchFoulsInfo extends ConsumerWidget {
  const HeadRefereeMatchFoulsInfo({super.key});

  Widget _allianceFouls(bool isRed) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey, width: 2),
                bottom: BorderSide(color: Colors.grey, width: 2),
                right: BorderSide(color: Colors.grey, width: 1),
              ),
            ),
            child: HeadRefereeFieldFouls(
              isMajor: isRed ? true : false,
              isRed: isRed,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey, width: 2),
                bottom: BorderSide(color: Colors.grey, width: 2),
                left: BorderSide(color: Colors.grey, width: 1),
              ),
            ),
            child: HeadRefereeFieldFouls(
              isMajor: isRed ? false : true,
              isRed: isRed,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(flex: 1, child: _allianceFouls(false)),

        Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey, width: 2),
              bottom: BorderSide(color: Colors.grey, width: 2),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: "TOTALS"
                .split('')
                .map(
                  (c) => Text(
                    c,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
                .toList(),
          ),
        ),
        Expanded(flex: 1, child: _allianceFouls(true)),
      ],
    );
  }
}
