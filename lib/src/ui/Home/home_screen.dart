import 'package:ehsan_chat/src/core/utils/resources/assets_manager.dart';
import 'package:ehsan_chat/src/core/widgets/chateo_icon.dart';
import 'package:ehsan_chat/src/providers/chat_provider.dart';
import 'package:ehsan_chat/src/providers/home_provider.dart';
import 'package:ehsan_chat/src/ui/chats/chats_screen.dart';
import 'package:ehsan_chat/src/ui/contacts/contacts_screen.dart';
import 'package:ehsan_chat/src/ui/settings/settings_screen.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeProvider homeProvider;
  late ChatProvider chatProvider;

  late PageController _controller;

  @override
  void initState() {
    homeProvider = context.read();
    chatProvider = context.read();
    chatProvider.connect();
    homeProvider.init();
    _controller = PageController(initialPage: homeProvider.navbarIndex);
    homeProvider.addListener(_onChange);
    super.initState();
  }

  @override
  void dispose() {
    homeProvider.removeListener(_onChange);
    super.dispose();
  }

  _onChange() {
    _controller.animateToPage(
      homeProvider.navbarIndex,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutQuad,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _controller,
        children: const [
          ChatsScreen(),
          ContactsScreen(),
          SettingsScreen(),
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
