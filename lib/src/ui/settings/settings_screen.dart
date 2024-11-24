import 'package:ehsan_chat/main.dart';
import 'package:ehsan_chat/src/core/utils/resources/config.dart';
import 'package:ehsan_chat/src/core/utils/resources/route.dart';
import 'package:ehsan_chat/src/data/services/remote/auth_service.dart';
import 'package:ehsan_chat/src/providers/audio_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            TextButton(
              onPressed: () => AuthService().logout().then(
                (_) {
                  if (!context.mounted) return null;
                  // context.read<AudioProvider>().stopAudio();
                  return Navigator.pushNamedAndRemoveUntil(
                    context,
                    Routes.splashRoute,
                    ModalRoute.withName(Routes.splashRoute),
                  );
                },
              ),
              child: const Text("LOGOUT"),
            ),
            const Text("More"),
            Text(
              Config.me.toString(),
              style: TextStyle(color: Colors.amber),
            ),
          ],
        ),
      ),
    );
  }
}
