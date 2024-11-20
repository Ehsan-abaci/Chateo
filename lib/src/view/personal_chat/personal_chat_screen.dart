import 'dart:developer';

import 'package:ehsan_chat/src/core/utils/resources/assets_manager.dart';
import 'package:ehsan_chat/src/core/widgets/chateo_icon.dart';
import 'package:ehsan_chat/src/model/conversation.dart';
import 'package:ehsan_chat/src/model/private.dart';
import 'package:ehsan_chat/src/providers/chat_provider.dart';
import 'package:ehsan_chat/src/view/personal_chat/widgets/message_field_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/resources/color_manager.dart';
import 'widgets/scrollabel_chat.dart';

class PersonalChat extends StatefulWidget {
  PersonalChat({super.key});

  @override
  State<PersonalChat> createState() => _PersonalChatState();
}

class _PersonalChatState extends State<PersonalChat> {
  late Private conv;

  late ChatProvider _chatProvider;

  late ThemeData _theme;

  @override
  void dispose() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _chatProvider.deselectConv());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log('build personal chat screen');
    _chatProvider = context.read<ChatProvider>();
    conv = _chatProvider.selectedConv as Private;

    _theme = Theme.of(context);

    return Scaffold(
      body: SizedBox(
        height: MediaQuery.sizeOf(context).height -
            MediaQuery.viewInsetsOf(context).bottom,
        child: Column(
          children: [
            _getAppbar(context),
            _getChatContent(),
            MessageFieldBottomSheet(id: conv.user!.id),
          ],
        ),
      ),
    );
  }

  _getChatContent() {
    return Expanded(
      child: ColoredBox(
        color: ColorManager.neutralDark,
        child: Selector<ChatProvider, Conversation?>(
          selector: (context, p1) => _getNewConversationIfCreated(p1.convs),
          shouldRebuild: (previous, next) => previous != next,
          builder: (context, conv, child) {
            if (conv == null) return const Align();
            return ScrollableChat(conv: conv);
          },
        ),
      ),
    );
  }

  Conversation? _getNewConversationIfCreated(List<Conversation> convs) {
    return convs.where((e) => e.id == conv.id).firstOrNull ??
        convs.where((e) {
          if (e is Private) {
            return e.user?.id == conv.user?.id;
          }
          return false;
        }).firstOrNull;
  }

  _getAppbar(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: _theme.scaffoldBackgroundColor,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const ChateoIcon(icon: AssetsIcon.chevronLeft, height: 30),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Container()),
              Text(
                conv.conversationName ?? conv.conversationType ?? "",
                style: _theme.textTheme.titleLarge,
              ),
              Consumer<ChatProvider>(
                builder: (context, chatProvider, child) => Text(
                  chatProvider.connectionState,
                  style: TextStyle(
                    fontSize: 12,
                    color: ColorManager.disabled,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
