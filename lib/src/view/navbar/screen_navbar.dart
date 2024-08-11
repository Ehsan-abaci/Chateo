import 'package:ehsan_chat/main.dart';
import 'package:ehsan_chat/src/core/utils/resources/assets_manager.dart';
import 'package:ehsan_chat/src/core/widgets/chateo_icon.dart';
import 'package:ehsan_chat/src/view/chats/chats_screen.dart';
import 'package:ehsan_chat/src/view/contacts/contacts_screen.dart';
import 'package:ehsan_chat/src/view/more/more_screen.dart';
import 'package:ehsan_chat/src/view/navbar/cubit/navbar_controller_cubit.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

late final myUserId;

class NavbarSceen extends StatefulWidget {
  NavbarSceen({super.key});

  @override
  State<NavbarSceen> createState() => _NavbarSceenState();
}

class _NavbarSceenState extends State<NavbarSceen> {
  final PageController _controller = PageController();

  int selectedIndex = 0;
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    myUserId = (await supabase
        .from("profiles")
        .select('int_id')
        .eq('id', supabase.auth.currentUser!.id)
        .single())['int_id'] as int;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _controller,
        children: [
          ChatsScreen(),
          ContactsScreen(),
          MoreScreen(),
        ],
      ),
      bottomNavigationBar:
          BlocConsumer<NavbarControllerCubit, NavbarControllerState>(
        listener: (context, state) {
          _controller.animateToPage(
            state.index,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutQuad,
          );
        },
        builder: (context, state) {
          return FlashyTabBar(
            height: 55,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            onItemSelected: (i) {
              context.read<NavbarControllerCubit>().changeIndex(i);
            },
            iconSize: 20,
            selectedIndex: state.index,
            items: [
              FlashyTabBarItem(
                activeColor: Theme.of(context).primaryColor,
                icon: ChateoIcon(
                  icon: AssetsIcon.message,
                  height: 32,
                ),
                title: const Text('Chats'),
              ),
              FlashyTabBarItem(
                activeColor: Theme.of(context).primaryColor,
                icon: ChateoIcon(
                  icon: AssetsIcon.group,
                  height: 32,
                ),
                title: const Text('Contacts'),
              ),
              FlashyTabBarItem(
                activeColor: Theme.of(context).primaryColor,
                icon: ChateoIcon(
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
