import 'package:ehsan_chat/src/core/utils/resources/assets_manager.dart';
import 'package:ehsan_chat/src/core/widgets/chateo_icon.dart';
import 'package:ehsan_chat/src/providers/audio_provider.dart';
import 'package:ehsan_chat/src/providers/chat_provider.dart';
import 'package:ehsan_chat/src/providers/home_provider.dart';
import 'package:ehsan_chat/src/providers/video_provider.dart';
import 'package:ehsan_chat/src/view/chats/chats_screen.dart';
import 'package:ehsan_chat/src/view/contacts/contacts_screen.dart';
import 'package:ehsan_chat/src/view/more/more_screen.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final connectionState = context
        .select<ChatProvider, String>((cProvider) => cProvider.connectionState);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          connectionState,
          style: theme.textTheme.titleLarge,
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: context.read<HomeProvider>().controller,
        children: const [
          ChatsScreen(),
          ContactsScreen(),
          MoreScreen(),
        ],
      ),
      bottomNavigationBar: Consumer<HomeProvider>(
        builder: (context, homeProvider, _) {
          return FlashyTabBar(
            height: 55,
            backgroundColor: theme.scaffoldBackgroundColor,
            onItemSelected: (i) {
              context.read<HomeProvider>().changeIndex(i);
            },
            iconSize: 20,
            selectedIndex: homeProvider.navbarIndex,
            items: [
              FlashyTabBarItem(
                activeColor: theme.primaryColor,
                icon: const ChateoIcon(
                  icon: AssetsIcon.message,
                  height: 32,
                ),
                title: const Text('Chats'),
              ),
              FlashyTabBarItem(
                activeColor: theme.primaryColor,
                icon: const ChateoIcon(
                  icon: AssetsIcon.group,
                  height: 32,
                ),
                title: const Text('Contacts'),
              ),
              FlashyTabBarItem(
                activeColor: theme.primaryColor,
                icon: const ChateoIcon(
                  icon: AssetsIcon.more,
                  height: 32,
                ),
                title: const Text('More'),
              ),
            ],
          );
        },
      ),
    );
  }
}
