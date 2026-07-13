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
        icon: Icon(Icons.logout),
        onPressed: () {
          ref.read(panelIdProvider.notifier).clearId();
          context.goNamed(AppRoute.splash.name);
        },
      ),
      // IconButton(
      //   icon: const Icon(Icons.settings_outlined),
      //   tooltip: 'Settings',
      //   onPressed: () => AppRoute.settings.push(context),
      // ),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canPop = context.canPop();
    final panelId = ref.watch(panelNameProvider);

    return AppBar(
      backgroundColor: null,
      automaticallyImplyLeading: false,
      leadingWidth: canPop ? 56 : 260,
      leading: Center(
        child: Text("Qualification 20/42", style: TextStyle(fontSize: 20)),
      ),
      title: Text(panelId, style: TextStyle(fontSize: 20)),
      actions: canPop
          ? []
          : [
              Text(
                "2:10",
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
