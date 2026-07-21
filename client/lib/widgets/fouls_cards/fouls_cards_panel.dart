import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ref_link/generated/api.pb.dart';
import 'package:ref_link/widgets/fouls_cards/card_assignment_view.dart';
import 'package:ref_link/widgets/fouls_cards/foul_buttons.dart';
import 'package:ref_link/widgets/fouls_cards/foul_counts.dart';
import 'package:ref_link/widgets/fouls_cards/fouls_cards_controller.dart';
import 'package:ref_link/widgets/fouls_cards/mode_buttons.dart';

/// Full fouls/cards editor (add/subtract minor+major fouls per alliance, cycle cards per
/// team) driven by a [FoulsCardsController] - shared by the referee's own panel and the head
/// referee's "Fouls/Cards" popup, which just wire the controller to a different panel provider.
class FoulsCardsPanel extends HookConsumerWidget {
  final FoulsCardsController controller;
  final MatchAllianceState redAlliance;
  final MatchAllianceState blueAlliance;

  /// Optional extra controls rendered above the foul buttons (e.g. the referee's own
  /// RP/discussion buttons and "To Endgame" button) - not shown while in card-assignment mode.
  final WidgetBuilder? overlayBuilder;

  const FoulsCardsPanel({
    super.key,
    required this.controller,
    required this.redAlliance,
    required this.blueAlliance,
    this.overlayBuilder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardMode = useState(false);
    final subtractionMode = useState(false);

    if (cardMode.value) {
      return FoulsCardsAssignmentView(
        controller: controller,
        redAlliance: redAlliance,
        blueAlliance: blueAlliance,
        onClose: () => cardMode.value = false,
      );
    }

    void updateFoul({required bool red, required bool major}) {
      if (subtractionMode.value) {
        controller.removeFoul(red: red, major: major);
        subtractionMode.value = false;
      } else {
        controller.addFoul(red: red, major: major);
      }
    }

    return Column(
      children: [
        Expanded(
          flex: 1,
          child: overlayBuilder?.call(context) ?? const SizedBox.shrink(),
        ),
        Expanded(
          flex: 4,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: FoulsCardsFoulButtons(
                  red: false,
                  subtractionMode: subtractionMode.value,
                  onMinorFoul: () => updateFoul(red: false, major: false),
                  onMajorFoul: () => updateFoul(red: false, major: true),
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 1,
                      child: FoulsCardsModeButtons(
                        onToggleSubtraction: () =>
                            subtractionMode.value = !subtractionMode.value,
                        onEnterCardMode: () => cardMode.value = true,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 100),
                        child: FoulsCardsFoulCounts(controller: controller),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: FoulsCardsFoulButtons(
                  red: true,
                  subtractionMode: subtractionMode.value,
                  onMinorFoul: () => updateFoul(red: true, major: false),
                  onMajorFoul: () => updateFoul(red: true, major: true),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
