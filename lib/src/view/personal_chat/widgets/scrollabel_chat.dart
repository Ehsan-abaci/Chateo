import 'dart:developer';

import 'package:ehsan_chat/src/model/message.dart';
import 'package:ehsan_chat/src/providers/chat_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../model/conversation.dart';
import 'chat_bubble.dart';

class ScrollableChat extends StatefulWidget {
  const ScrollableChat({
    super.key,
    required this.conv,
  });

  final Conversation conv;

  @override
  State<ScrollableChat> createState() => _ScrollableChatState();
}

class _ScrollableChatState extends State<ScrollableChat> {
  late ChatProvider _chatProvider;

  ValueNotifier<bool> isScrollForwrding = ValueNotifier(false);

  void scrollToEnd() async {
    await _chatProvider.chatListScrollController.scrollTo(
      index: 0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.linear,
    );
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _chatProvider.saveLastViewPortSeenIndex(widget.conv);
      isScrollForwrding.value = false;
    });
  }

  @override
  void initState() {
    _chatProvider = context.read<ChatProvider>();

    Future.microtask(() => _chatProvider.chatListScrollController.jumpTo(
          index: _chatProvider.selectedConv!.minViewPortSeenIndex,
        ));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log('build scroll');
    return Stack(
      children: [
        NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (kIsWeb) {
              return true;
            }
            if (notification is UserScrollNotification) {
              if (notification.direction == ScrollDirection.forward) {
                isScrollForwrding.value = true;
              } else if (notification.direction == ScrollDirection.reverse) {
                isScrollForwrding.value = false;
              }
            } else if (notification is ScrollEndNotification) {
              if (_chatProvider.minIndexOfChatListOnViewPort == 0) {
                isScrollForwrding.value = false;
              }
              SchedulerBinding.instance.addPostFrameCallback((_) {
                _chatProvider.saveLastViewPortSeenIndex(widget.conv);
              });
            }
            return true;
          },
          child: Selector<ChatProvider, List<Message>>(
            selector: (context, chatProvider) => chatProvider.convs
                .firstWhere((e) => e.id == widget.conv.id)
                .msgList,
            shouldRebuild: (previous, next) => previous.length != next.length,
            builder: (context, mesages, child) {
              if (mesages.isEmpty) {
                return const Align();
              }
              return ScrollablePositionedList.builder(
                itemScrollController: _chatProvider.chatListScrollController,
                itemPositionsListener: _chatProvider.chatListScrollListener,
                scrollDirection: Axis.vertical,
                minCacheExtent: 500,
                reverse: true,
                itemCount: mesages.length,
                itemBuilder: (context, i) => ChatBubble(
                  message: mesages[i],
                ),
              );
            },
          ),
        ),
        Positioned(
          bottom: 10,
          right: 0,
          child: ValueListenableBuilder(
            valueListenable: isScrollForwrding,
            builder: (context, value, child) {
              final chatProvider = context.watch<ChatProvider>();
              final lengthOfNewMessages =
                  (chatProvider.selectedConv?.msgList.length ?? 0) -
                      1 -
                      (chatProvider.selectedConv?.lastIndex ?? 0);
              return value
                  ? lengthOfNewMessages > 0
                      ? BadgedScrollButton(
                          lengthOfNewMessages: lengthOfNewMessages,
                          scrollToEnd: scrollToEnd,
                        )
                      : ScrollButton(
                          scrollToEnd: scrollToEnd,
                        )
                  : const Align();
            },
          ),
        )
      ],
    );
  }
}

class BadgedScrollButton extends StatelessWidget {
  const BadgedScrollButton({
    super.key,
    required this.lengthOfNewMessages,
    required this.scrollToEnd,
  });
  final int lengthOfNewMessages;
  final VoidCallback scrollToEnd;

  @override
  Widget build(BuildContext context) {
    return Badge(
      label: Text('$lengthOfNewMessages'),
      offset: const Offset(-10, 0),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            padding: EdgeInsets.zero,
            shape: const CircleBorder(),
          ),
          onPressed: scrollToEnd,
          child: const Icon(CupertinoIcons.down_arrow)),
    );
  }
}

class ScrollButton extends StatelessWidget {
  const ScrollButton({
    super.key,
    required this.scrollToEnd,
  });

  final VoidCallback scrollToEnd;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          padding: EdgeInsets.zero,
          shape: const CircleBorder(),
        ),
        onPressed: scrollToEnd,
        child: const Icon(CupertinoIcons.down_arrow));
  }
}
