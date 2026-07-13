import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ref_link/colors.dart';
import 'package:ref_link/theme.dart';
import 'package:ref_link/router/router.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode =
        ThemeMode.dark; // no light mode at this time (i'm on a time crunch)

    final primaryColor = Color(0xFF009485);
    final secondaryColor = Color(0xFF005994);

    return MaterialApp.router(
      title: 'Ref Link',
      debugShowCheckedModeBanner: true,
      routerConfig: ref.watch(routerProvider),
      themeMode: themeMode,
      darkTheme: buildDarkTheme(
        createMaterialColor(primaryColor),
        createMaterialColor(secondaryColor),
      ),
      themeAnimationDuration: Duration.zero,
    );
  }
}
