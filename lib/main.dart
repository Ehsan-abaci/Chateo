import 'package:ehsan_chat/src/core/utils/locator.dart';
import 'package:ehsan_chat/src/core/utils/resources/route.dart';
import 'package:ehsan_chat/src/providers/audio_provider.dart';
import 'package:ehsan_chat/src/providers/chat_provider.dart';
import 'package:ehsan_chat/src/providers/video_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit/media_kit.dart';
import 'package:provider/provider.dart';
import 'src/config/theme_config.dart';
import 'src/core/cubit/theme/theme_cubit.dart';
import 'src/view/chats/cubits/search_user/search_user_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();

  await initAppModule();

  runApp(
    BlocProvider(
      create: (context) => ThemeCubit(),
      child: const MyApp(),
    ),
  );
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SearchUserCubit(di()),
        ),
      ],
      child: MaterialApp(
        // navigatorKey: navigatorKey,
        title: "Flutter Chat Application",
        debugShowCheckedModeBanner: false,
        // theme: context.watch<ThemeCubit>().state.theme,
        theme: ThemeConfig.darkTheme(),
        onGenerateRoute: RouteGenerator.getRoute,
      ),
    );
  }
}
