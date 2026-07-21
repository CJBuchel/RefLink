import 'package:ref_link/generated/api.pbenum.dart';

/// Decouples the fouls/cards UI from a specific panel provider (a referee's own panel vs
/// the head referee's panel) so the same widgets can drive either one.
class FoulsCardsController {
  final int Function({required bool red, required bool major}) foulCount;
  final void Function({required bool red, required bool major}) addFoul;
  final void Function({required bool red, required bool major}) removeFoul;
  final CardType Function(TeamAllianceStationType station) cardState;
  final void Function(CardType card, TeamAllianceStationType station) setCardState;

  const FoulsCardsController({
    required this.foulCount,
    required this.addFoul,
    required this.removeFoul,
    required this.cardState,
    required this.setCardState,
  });
}
