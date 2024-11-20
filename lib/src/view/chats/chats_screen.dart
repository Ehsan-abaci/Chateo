import 'package:ehsan_chat/src/core/utils/dbouncer.dart';
import 'package:ehsan_chat/src/core/utils/resources/assets_manager.dart';
import 'package:ehsan_chat/src/core/widgets/chateo_icon.dart';
import 'package:ehsan_chat/src/core/widgets/chateo_my_story_widget.dart';
import 'package:ehsan_chat/src/core/widgets/chateo_story_widget.dart';
import 'package:ehsan_chat/src/model/conversation.dart';
import 'package:ehsan_chat/src/providers/chat_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubits/search_user/search_user_cubit.dart';
import 'widgets/chat_list_user_card.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final TextEditingController searchController = TextEditingController();

  final Dbouncer dbouncer = Dbouncer();

  @override
  Widget build(BuildContext context) {
    final convs =
        context.select<ChatProvider, List<Conversation>>((cp) => cp.convs);
    final theme = Theme.of(context);
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
              final searchedUsers = state.users;
              if (searchedUsers.isEmpty) return const SliverToBoxAdapter();
              return SliverList.list(
                children: [
                  ...searchedUsers
                      .map((user) => ChatListUserCard(conversation: user)),
                  Divider(
                    color: Colors.black.withOpacity(0.2),
                    endIndent: 20,
                    indent: 20,
                  ),
                ],
              );
            },
          ),
          SliverList.list(
            children: [
              ...convs
                  .map((conv) => ChatListUserCard(conversation: conv)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getSliverAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Chateo"),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const ChateoIcon(
                  icon: AssetsIcon.messageAlt,
                  height: 24,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const ChateoIcon(
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
                ? const ChateoMyStoryWidget()
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
            strutStyle: const StrutStyle(
              height: 2,
              forceStrutHeight: true,
            ),
            controller: searchController,
            onChanged: (value) async {
              dbouncer.call(() {
                context.read<SearchUserCubit>().searchUsersByUsername(value);
              });
            },
            style: Theme.of(context).textTheme.titleMedium,
            decoration: const InputDecoration(
              hintText: "Search",
              prefixIcon: Icon(CupertinoIcons.search),
            ),
          ),
        ),
      ),
    );
  }
}
