import 'dart:developer';

import 'package:ehsan_chat/src/core/utils/locator.dart';
import 'package:ehsan_chat/src/model/signup_request.dart';
import 'package:ehsan_chat/src/providers/chat_provider.dart';
import 'package:ehsan_chat/src/providers/home_provider.dart';
import 'package:ehsan_chat/src/providers/personal_chat_cubit.dart';
import 'package:ehsan_chat/src/view/Home/home_screen.dart';
import 'package:ehsan_chat/src/view/login/bloc/login_bloc.dart';
import 'package:ehsan_chat/src/view/login/login_screen.dart';
import 'package:ehsan_chat/src/view/onboarding/onboarding_screen.dart';
import 'package:ehsan_chat/src/view/register/blocs/opt/otp_bloc.dart';
import 'package:ehsan_chat/src/view/register/otp_screen.dart';
import 'package:ehsan_chat/src/view/register/register_screen.dart';
import 'package:ehsan_chat/src/view/splash/cubit/splash_cubit.dart';
import 'package:ehsan_chat/src/view/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../providers/audio_provider.dart';
import '../../../providers/video_provider.dart';
import '../../../view/personal_chat/personal_chat_screen.dart';
import '../../../view/register/blocs/register/register_bloc.dart';

class Routes {
  static const String splashRoute = '/';
  static const String onboardingRoute = '/onboarding';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String otpRoute = '/otp';
  static const String homeRoute = '/home';
  static const String personalChat = '/personal-chat';
}

class RouteGenerator {
  static Route getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) {
          // clearHomeModule();
          return BlocProvider(
            create: (context) => SplashCubit(),
            child: const SplashScreen(),
          );
        });
      case Routes.onboardingRoute:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case Routes.loginRoute:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => LoginBloc(),
            child: LoginScreen(),
          ),
        );
      case Routes.registerRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => RegisterBloc(),
            child: RegisterScreen(),
          ),
        );
      case Routes.otpRoute:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => OtpBloc(),
              ),
              BlocProvider(
                create: (context) => RegisterBloc(),
              ),
            ],
            child: OtpScreen(
              signupRequest: routeSettings.arguments as SignupRequest,
            ),
          ),
        );
      case Routes.homeRoute:
        return MaterialPageRoute(
          builder: (_) {
            initHomeModule();
            return MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (context) => di<ChatProvider>()..connect(),
                ),
                ChangeNotifierProvider(
                  create: (context) => di<AudioProvider>(),
                ),
                ChangeNotifierProvider(
                  create: (context) => di<VideoProvider>(),
                ),
                ChangeNotifierProvider(
                  create: (context) => di<HomeProvider>(),
                ),
              ],
              child: const HomeScreen(),
            );
          },
        );
      case Routes.personalChat:
        return MaterialPageRoute(
          builder: (_) {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider.value(
                  value: di<ChatProvider>(),
                ),
                ChangeNotifierProvider.value(
                  value: di<VideoProvider>(),
                ),
                ChangeNotifierProvider.value(
                  value: di<AudioProvider>(),
                ),
                ChangeNotifierProxyProvider<ChatProvider, PersonalChatProvider>(
                  create: (c) => PersonalChatProvider(),
                  update: (context, chatProvider, previous) =>
                      previous!..initChatProvider(chatProvider),
                ),
              ],
              child: PersonalChat(),
            );
          },
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
    }
  }
}
