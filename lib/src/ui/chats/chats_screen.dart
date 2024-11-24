import 'package:ehsan_chat/src/core/utils/dbouncer.dart';
import 'package:ehsan_chat/src/core/utils/resources/assets_manager.dart';
import 'package:ehsan_chat/src/core/widgets/chateo_icon.dart';
import 'package:ehsan_chat/src/core/widgets/chateo_my_story_widget.dart';
import 'package:ehsan_chat/src/core/widgets/chateo_story_widget.dart';
import 'package:ehsan_chat/src/model/conversation.dart';
import 'package:ehsan_chat/src/providers/chat_provider.dart';
import 'package:ehsan_chat/src/ui/chats/view_models/chats_viewmodel.dart';
import 'package:ehsan_chat/src/ui/chats/widgets/audio_bar_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widgets/chat_list_user_card.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> with AutomaticKeepAliveClientMixin{
  final TextEditingController searchController = TextEditingController();

  final Dbouncer dbouncer = Dbouncer();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final convs =
        context.select<ChatProvider, List<Conversation>>((cp) => cp.convs);
    return Padding(
      padding: const EdgeInsets.all(0),
      child: CustomScrollView(
        slivers: [
          const SliverChatAppBar(),
          _getSliverStoryBar(),
          _getDivider(context),
          _getSearchBar(),
          _getAudioController(),
          Selector<ChatsViewModel, List<Conversation>>(
            selector: (_, chatViewModel) => chatViewModel.serchedUsers,
            builder: (context, searchedUsers, _) {
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
              ...convs.map((conv) => ChatListUserCard(conversation: conv)),
            ],
          ),
        ],
      ),
    );
  }

  _getAudioController() =>
      const SliverToBoxAdapter(child: AudioBarController());

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
        height: 80,
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
      toolbarHeight: 80,
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
                context.read<ChatsViewModel>().searchUsersByUsername(value);
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
  
  @override
  bool get wantKeepAlive => true;
}

class SliverChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SliverChatAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final connectionState = context.select<ChatProvider, String>(
        (cProvider) => cProvider.connectionState.state);
    final theme = Theme.of(context);
    return SliverAppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            connectionState,
            style: theme.textTheme.titleLarge,
          ),
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

  @override
  Size get preferredSize => const Size.fromHeight(500);
}
