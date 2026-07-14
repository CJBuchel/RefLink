import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ref_link/providers/network_config_provider.dart';

class SettingsView extends HookConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController controller = TextEditingController();
    final currentIp = ref.watch(serverIpProvider);
    controller.text = currentIp;

    void onConnect() {
      ref.read(serverIpProvider.notifier).setIp(controller.text);
      if (context.canPop()) context.pop();
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 500,
            child: TextField(
              controller: controller,
              maxLength: 15,
              autofocus: true,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 30, letterSpacing: 12),
              decoration: InputDecoration(
                counterText: '',
                labelText: 'Enter Server Address',
                hintText: '127.0.0.1',
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
              onPressed: onConnect,
              child: Text("Connect", style: TextStyle(fontSize: 30)),
            ),
          ),
        ],
      ),
    );
  }
}
