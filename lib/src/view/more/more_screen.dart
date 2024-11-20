import 'package:ehsan_chat/src/core/utils/resources/config.dart';
import 'package:ehsan_chat/src/core/utils/resources/route.dart';
import 'package:ehsan_chat/src/data/remote/auth_date_source.dart';
import 'package:flutter/material.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            TextButton(
              onPressed: () => AuthDataSource().logout().then(
                (_) {
                  if (!context.mounted) return null;
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
