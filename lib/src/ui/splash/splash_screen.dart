import 'package:ehsan_chat/src/core/utils/resources/assets_manager.dart';
import 'package:ehsan_chat/src/core/utils/resources/route.dart';
import 'package:ehsan_chat/src/ui/splash/view_models/splash_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SplashViewModel splashViewModel;
  @override
  void initState() {
    splashViewModel = context.read<SplashViewModel>();
    splashViewModel.init();
    splashViewModel.addListener(_onResult);
    super.initState();
  }

  @override
  void dispose() {
    splashViewModel.removeListener(_onResult);
    super.dispose();
  }

  _onResult() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      if (splashViewModel.isAuthenticated) {
        Navigator.pushReplacementNamed(context, Routes.homeRoute);
      } else {
        precacheImage(const AssetImage(AssetsImage.onboarding), context);
        Navigator.pushReplacementNamed(context, Routes.onboardingRoute);
      }
    }
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
