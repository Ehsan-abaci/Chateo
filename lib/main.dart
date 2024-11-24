import 'package:ehsan_chat/src/core/utils/locator.dart';
import 'package:ehsan_chat/src/core/utils/resources/route.dart';
import 'package:ehsan_chat/src/core/widgets/scroll_behavior.dart';
import 'package:ehsan_chat/src/ui/chats/view_models/chats_viewmodel.dart';
import 'package:ehsan_chat/src/ui/splash/view_models/splash_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:provider/provider.dart';
import 'src/config/theme_config.dart';

class MyWrapper extends StatelessWidget {
  const MyWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SplashViewModel(),
      builder: (context, _) => MultiProvider(
        key: context.watch<SplashViewModel>().isAuthenticated == false
            ? UniqueKey()
            : null,
        providers: providers,
        child: const MyApp(),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();

  await initAppModule();

  runApp(MyWrapper());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ChatsViewModel(di()),
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: "Flutter Chat Application",
        debugShowCheckedModeBanner: false,
        scrollBehavior: AppCustomScrollBehavior(),
        // theme: context.watch<ThemeCubit>().state.theme,
        theme: ThemeConfig.ligthTheme(),
        darkTheme: ThemeConfig.darkTheme(),
        themeMode: ThemeMode.system,
        onGenerateRoute: RouteGenerator.getRoute,
      ),
    );
  }
}
