import 'package:ehsan_chat/src/model/signup_request.dart';
import 'package:ehsan_chat/src/providers/chat_provider.dart';
import 'package:ehsan_chat/src/providers/home_provider.dart';
import 'package:ehsan_chat/src/providers/personal_chat_provider.dart';
import 'package:ehsan_chat/src/ui/Home/home_screen.dart';
import 'package:ehsan_chat/src/ui/login/login_screen.dart';
import 'package:ehsan_chat/src/ui/login/view_models/login_viewmodel.dart';
import 'package:ehsan_chat/src/ui/onboarding/onboarding_screen.dart';
import 'package:ehsan_chat/src/ui/register/otp_screen.dart';
import 'package:ehsan_chat/src/ui/register/register_screen.dart';
import 'package:ehsan_chat/src/ui/register/view_models/otp_viewmodel.dart';
import 'package:ehsan_chat/src/ui/register/view_models/register_viewmodel.dart';
import 'package:ehsan_chat/src/ui/splash/splash_screen.dart';
import 'package:ehsan_chat/src/ui/splash/view_models/splash_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../../../providers/audio_provider.dart';
import '../../../providers/video_provider.dart';
import '../../../ui/personal_chat/personal_chat_screen.dart';

class Routes {
  static const String splashRoute = '/';
  static const String onboardingRoute = '/onboarding';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String otpRoute = '/otp';
  static const String homeRoute = '/home';
  static const String personalChat = '/personal-chat';
}

List<SingleChildWidget> providers = [
  // ChangeNotifierProvider(create: (context) => SplashViewModel()),
  ChangeNotifierProvider(create: (context) => LoginViewModel()),
  ChangeNotifierProvider(create: (context) => RegisterViewModel()),
  ChangeNotifierProvider(create: (context) => OtpViewModel()),
  ChangeNotifierProvider(create: (context) => VideoProvider()),
  ChangeNotifierProvider(create: (context) => AudioProvider()),
  ChangeNotifierProvider(create: (context) => ChatProvider()),
  ChangeNotifierProvider(create: (context) => HomeProvider()),
  ChangeNotifierProxyProvider<ChatProvider, PersonalChatProvider>(
    create: (context) => PersonalChatProvider(),
    update: (context, chatProvider, previous) =>
        previous!..initChatProvider(chatProvider),
  ),
];

class RouteGenerator {
  static Route getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
      case Routes.onboardingRoute:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case Routes.loginRoute:
        return MaterialPageRoute(
          builder: (context) => LoginScreen(),
        );
      case Routes.registerRoute:
        return MaterialPageRoute(
          builder: (_) => RegisterScreen(),
        );
      case Routes.otpRoute:
        return MaterialPageRoute(
          builder: (_) => OtpScreen(
            signupRequest: routeSettings.arguments as SignupRequest,
          ),
        );
      case Routes.homeRoute:
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        );
      case Routes.personalChat:
        return MaterialPageRoute(
          builder: (context) => PersonalChat(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
    }
  }
}
