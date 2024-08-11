import 'package:ehsan_chat/src/core/utils/dbouncer.dart';
import 'package:ehsan_chat/src/core/utils/resources/assets_manager.dart';
import 'package:ehsan_chat/src/core/utils/resources/color_manager.dart';
import 'package:ehsan_chat/src/core/utils/resources/route.dart';
import 'package:ehsan_chat/src/core/widgets/chateo_icon.dart';
import 'package:ehsan_chat/src/core/widgets/chateo_my_story_widget.dart';
import 'package:ehsan_chat/src/core/widgets/chateo_story_widget.dart';
import 'package:ehsan_chat/src/model/user.dart';
import 'package:ehsan_chat/src/view/chats/cubits/saved_chats/saved_chats_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubits/search_user/search_user_cubit.dart';

class ChatsScreen extends StatefulWidget {
  ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen>
    with AutomaticKeepAliveClientMixin {
  List<Users> searchedUsers = [];
  List<Users> savedUsers = [];

  final TextEditingController searchController = TextEditingController();

  final Dbouncer dbouncer = Dbouncer();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    savedUsers = context.read<SavedChatsCubit>().state.savedChats;
    final h = MediaQuery.sizeOf(context).height;
    return Padding(
      padding: const EdgeInsets.all(0),
      child: CustomScrollView(
        slivers: [
          _getSliverAppBar(context),
          _getSliverStoryBar(),
          _getDivider(context),
          _getSearchBar(),
          BlocBuilder<SearchUserCubit, SearchUserState>(
            builder: (context, state) {
              searchedUsers = state.users;
              if (searchedUsers.isEmpty) return const SliverToBoxAdapter();
              return SliverList.list(
                children: [
                  ...searchedUsers.map((user) => _getUserCard(user)),
                  Divider(
                    color: Colors.black.withOpacity(0.2),
                    endIndent: 20,
                    indent: 20,
                  ),
                ],
              );
            },
          ),
          BlocBuilder<SavedChatsCubit, SavedChatsState>(
            builder: (context, state) {
              savedUsers = state.savedChats;
              return SliverList.list(
                children: [
                  ...savedUsers.map((user) => _getUserCard(user)),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _getUserCard(Users user) {
    return ListTile(
      onTap: () =>
          Navigator.pushNamed(context, Routes.personalChat, arguments: user),
      title: Text(
        user.fullname,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
      ),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: 48,
          width: 48,
          child: ColoredBox(
            color: ColorManager.lightBlue,
            child: Center(
              child: Text(
                user.fullname.split(" ")[0][0].toUpperCase() +
                    user.fullname.split(" ")[1][0].toUpperCase(),
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getSliverAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Chats"),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: ChateoIcon(
                  icon: AssetsIcon.messageAlt,
                  height: 24,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: ChateoIcon(
                  icon: AssetsIcon.listCheck,
                  height: 24,
                ),
              ),
            ],
          ),
        ],
      ),
      pinned: true,
    );
  }

  Widget _getSliverStoryBar() {
    return SliverAppBar(
      primary: false,
      backgroundColor: Colors.transparent,
      title: SizedBox(
        height: 108,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          primary: true,
          itemBuilder: (context, i) => Padding(
            padding: const EdgeInsets.only(right: 16),
            child: i == 0
                ? ChateoMyStoryWidget()
                : ChateoStoryWidget(
                    image: "$IMAGE_PATH/user$i.png",
                    name: "Ehsan",
                  ),
          ),
          itemCount: 5,
        ),
      ),
      toolbarHeight: 108,
    );
  }

  _getDivider(BuildContext context) {
    return const SliverToBoxAdapter(
      child: Divider(),
    );
  }

  _getSearchBar() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: TextField(
            controller: searchController,
            onChanged: (value) async {
              if (value == "") {
                setState(() {
                  searchedUsers = [];
                });
                return;
              }
              dbouncer.call(() async {
                context.read<SearchUserCubit>().searchUsersByUsername(value);
              });
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: ColorManager.offWhite,
              border: InputBorder.none,
              hintText: "Search",
              prefixIcon: const Icon(CupertinoIcons.search),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
