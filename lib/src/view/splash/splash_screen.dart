import 'dart:developer';

import 'package:ehsan_chat/main.dart';
import 'package:ehsan_chat/src/core/utils/resources/route.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    await Future.delayed(const Duration(seconds: 2)).then((_) async{
      //  await supabase.auth.signOut();
      final session = supabase.auth.currentSession;
      if (session == null) {
        Navigator.of(context).pushReplacementNamed(Routes.registerRoute);
      } else {
        Navigator.of(context).pushReplacementNamed(Routes.homeRoute);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Chateo",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 50,
          ),
        ),
      ),
    );
  }
}
