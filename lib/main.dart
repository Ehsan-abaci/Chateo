import 'package:ehsan_chat/src/config/cubit/theme_cubit.dart';
import 'package:ehsan_chat/src/config/theme_config.dart';
import 'package:ehsan_chat/src/core/utils/constants.dart';
import 'package:ehsan_chat/src/core/utils/locator.dart';
import 'package:ehsan_chat/src/core/utils/resources/route.dart';
import 'package:ehsan_chat/src/view/chats/cubits/saved_chats/saved_chats_cubit.dart';
import 'package:ehsan_chat/src/view/navbar/cubit/navbar_controller_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'src/view/chats/cubits/search_user/search_user_cubit.dart';

/// Supabase client
final supabase = Supabase.instance.client;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: Constants.supabaseUrl,
    anonKey: Constants.supabaseAnonKey,
  );
  await initAppModule();

  runApp(
    BlocProvider(
      create: (context) => ThemeCubit(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NavbarControllerCubit(),
        ),
        BlocProvider(
          create: (context) => SearchUserCubit(),
        ),
        BlocProvider(
          create: (context) => SavedChatsCubit()..getChats(),
        ),
      ],
      child: MaterialApp(
        title: "Flutter Chat Application",
        debugShowCheckedModeBanner: false,
        theme: context.watch<ThemeCubit>().state.theme,
        // theme: ThemeConfig.darkTheme(),
        onGenerateRoute: RouteGenerator.getRoute,
      ),
    );
  }
}
