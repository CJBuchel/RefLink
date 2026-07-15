import 'package:ref_link/providers/fms_provider.dart';
import 'package:ref_link/providers/health_provider.dart';
import 'package:ref_link/providers/panel_id_provider.dart';
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canPop = context.canPop();
    final panelId = ref.watch(panelNameProvider);
    final isConnected = ref.watch(isConnectedProvider).value ?? false;
    final matchInfo = ref.watch(arenaMatchInfoProvider).value;

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
      leadingWidth: 260,
      leading: Center(
        child: Text(matchLabel, style: TextStyle(fontSize: 20)),
      ),
      title: getTitle(),
      actions: canPop
          ? []
          : [
              Text(
                timerLabel,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 40),
              ..._actions(context, ref),
            ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
