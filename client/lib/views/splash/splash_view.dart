import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ref_link/models/panel_types.dart';
import 'package:ref_link/providers/panel_id_provider.dart';
import 'package:ref_link/router/app_routes.dart';
import 'package:ref_link/widgets/dialogs/popup_dialog.dart';

class SplashView extends HookConsumerWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController controller = TextEditingController();

    void onLogin() {
      // verify panel type id
      try {
        getPanelFromString(controller.text);
        ref.read(panelIdProvider.notifier).setId(controller.text);
        context.goNamed(
          AppRoute.referee.name,
          pathParameters: {'id': controller.text},
        );
      } catch (e) {
        PopupDialog.error(
          title: "Invalid Panel",
          message: Text(e.toString()),
        ).show(context);
      }
    }

    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 300,
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  autofocus: true,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 48, letterSpacing: 12),
                  decoration: InputDecoration(
                    counterText: '',
                    labelText: 'Enter PIN',
                    hintText: '0000',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(width: 2),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsGeometry.all(20),
                child: ElevatedButton(
                  onPressed: onLogin,
                  child: Text("Login", style: TextStyle(fontSize: 35)),
                ),
              ),
            ],
          ),
        ),

        // Positioned help text
        Positioned(
          left: 20,
          bottom: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "1111 - Head Referee",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Text(
                "2222 - Red Near",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Text(
                "3333 - Red Far",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Text(
                "4444 - Blue Near",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Text(
                "5555 - Blue Far",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
