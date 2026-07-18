import 'package:ref_link/colors.dart';
import 'package:ref_link/providers/fms_provider.dart';
import 'package:ref_link/providers/health_provider.dart';
import 'package:ref_link/providers/panel_id_provider.dart';
import 'package:ref_link/providers/rotation_provider.dart';
import 'package:ref_link/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BaseAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final GoRouterState state;
  final bool showActions;

  const BaseAppBar({super.key, required this.state, this.showActions = true});

  List<Widget> _actions(BuildContext context, WidgetRef ref) {
    if (!showActions) return [];
    return [
      IconButton(
        icon: const Icon(Icons.settings_outlined),
        tooltip: 'Settings',
        onPressed: () => AppRoute.settings.push(context),
      ),
      IconButton(
        icon: Icon(Icons.logout),
        onPressed: () {
          ref.read(panelIdProvider.notifier).clearId();
          context.goNamed(AppRoute.splash.name);
        },
      ),
    ];
  }

  Widget _rotationBadge(int rotateIn) {
    final urgent = rotateIn <= 1;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: urgent ? arenaAmber : surfaceColor.shade700,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: urgent ? Colors.black : surfaceBorder),
      ),
      child: Text(
        rotateIn <= 0 ? "Rotate now" : "Rotate in $rotateIn",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: urgent ? Colors.white : labelFaint,
        ),
      ),
    );
  }

  Widget _matchBadge(String matchLabel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.blue.shade900,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: surfaceBorder),
      ),
      child: Text(
        matchLabel,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: labelFaint,
        ),
      ),
    );
  }

  Widget _timerBadge(String timerLabel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: surfaceBorder),
      ),
      child: Text(
        timerLabel,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canPop = context.canPop();
    final panelId = ref.watch(panelNameProvider);
    final isConnected = ref.watch(isConnectedProvider).value ?? false;
    final matchInfo = ref.watch(arenaMatchInfoProvider).value;
    final rotateIn = ref.watch(rotationStatusProvider);

    final matchLabel = matchInfo == null || matchInfo.matchNumber == 0
        ? "No Match"
        : "${matchTypeLabel(matchInfo.matchType)} ${matchInfo.matchNumber}";
    final timerLabel = matchTimerLabel(matchInfo?.timeRemainingSec ?? 0);

    Widget getTitle() {
      if (isConnected) {
        return Text(panelId, style: TextStyle(fontSize: 20));
      } else {
        return Text(
          "Disconnected",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        );
      }
    }

    return AppBar(
      backgroundColor: isConnected ? null : Colors.red,
      automaticallyImplyLeading: false,
      leadingWidth: 320,
      leading: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _matchBadge(matchLabel),
            const SizedBox(width: 10),
            _rotationBadge(rotateIn),
          ],
        ),
      ),
      title: getTitle(),
      actions: canPop
          ? []
          : [
              _timerBadge(timerLabel),
              SizedBox(width: 40),
              ..._actions(context, ref),
            ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
