import 'package:ehsan_chat/src/core/utils/resources/assets_manager.dart';
import 'package:ehsan_chat/src/core/utils/resources/route.dart';
import 'package:ehsan_chat/src/view/splash/cubit/splash_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) async{
       await Future.delayed(const Duration(seconds: 2));
        if (state.isLogged) {
          Navigator.pushReplacementNamed(context, Routes.homeRoute);
        } else {
          precacheImage(const AssetImage(AssetsImage.onboarding), context);
          Navigator.pushReplacementNamed(context, Routes.onboardingRoute);
        }
      },
      child: Scaffold(
        body: Center(
          child: Text(
            "Chateo",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 50,
            ),
          ),
        ),
      ),
    );
  }
}
