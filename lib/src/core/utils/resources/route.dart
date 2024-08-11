import 'package:ehsan_chat/src/model/user.dart';
import 'package:ehsan_chat/src/view/login/login_screen.dart';
import 'package:ehsan_chat/src/view/navbar/screen_navbar.dart';
import 'package:ehsan_chat/src/view/personal_chat/cubit/messages_cubit.dart';
import 'package:ehsan_chat/src/view/personal_chat/personal_chat.screen.dart';
import 'package:ehsan_chat/src/view/register/register_screen.dart';
import 'package:ehsan_chat/src/view/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Routes {
  static const String splashRoute = '/';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String homeRoute = '/home';
  static const String personalChat = '/personal-chat';
}

class RouteGenerator {
  static Route getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case Routes.loginRoute:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );
      case Routes.registerRoute:
        return MaterialPageRoute(
          builder: (_) => const RegisterScreen(),
        );

      case Routes.homeRoute:
        return MaterialPageRoute(
          builder: (_) => NavbarSceen(),
        );
      case Routes.personalChat:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => MessagesCubit()..initialMessages(),
            child: PersonalChat(
              user: routeSettings.arguments as Users,
            ),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
    }
  }
}
