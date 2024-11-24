import 'package:ehsan_chat/src/core/utils/extensions.dart';
import 'package:ehsan_chat/src/model/conversation.dart';
import 'package:ehsan_chat/src/providers/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/resources/color_manager.dart';
import '../../../core/utils/resources/route.dart';

class ChatListUserCard extends StatelessWidget {
  const ChatListUserCard({
    super.key,
    required this.conversation,
  });

  final Conversation conversation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(5),
      child: ListTile(
        shape:
            ContinuousRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onTap: () {
          context.read<ChatProvider>().selectConv(conversation);
          Navigator.pushNamed(context, Routes.personalChat);
        },
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              conversation.conversationName ?? 'Guest',
              style: theme.textTheme.titleMedium,
            ),
            Text(
              conversation.lastMsg?.createdAt!.toUserCardTime ?? '',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height: 48,
            width: 48,
            child: ColoredBox(
              color: ColorManager.lightBlue,
              child: Conversation.generateProfileImageByName(conversation),
            ),
          ),
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                '',
                // conversation.lastMsg?.content.toLastMsgFormat() ?? '',
                style: theme.textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (conversation.msgList.length - 1 > (conversation.lastIndex ?? 0))
              Badge.count(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                backgroundColor: ColorManager.brandDefault,
                count: (conversation.msgList.length -
                    1 -
                    (conversation.lastIndex ?? 0)),
              ),
          ],
        ),
      ),
    );
  }
}
