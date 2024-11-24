import 'dart:developer';

import 'package:ehsan_chat/main.dart';
import 'package:ehsan_chat/src/core/utils/extensions.dart';
import 'package:ehsan_chat/src/core/utils/locator.dart';
import 'package:ehsan_chat/src/core/utils/resources/color_manager.dart';
import 'package:ehsan_chat/src/model/audio_message.dart';
import 'package:ehsan_chat/src/ui/personal_chat/widgets/video_message_item.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../model/message.dart';
import '../../../model/video_message.dart';
import '../../../providers/audio_provider.dart';
import '../../../providers/video_provider.dart';
import 'audio_message_item.dart';
import 'photo_message_item.dart';

class ChatBubble extends StatefulWidget {
  ChatBubble({
    super.key,
    required this.message,
  });

  Message message;

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  late VideoProvider videoProvider;
  late AudioProvider audioProvider;

  @override
  void initState() {
    videoProvider = context.read();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log("Chat bubble");
    List<Widget> chatContents = [
      const SizedBox(width: 8),
      Flexible(
        child: Container(
          padding: EdgeInsets.zero,
          margin: EdgeInsets.zero,
          decoration: BoxDecoration(
            color: widget.message.isMyMessage()
                ? ColorManager.brandDarkMode
                : Colors.white,
            borderRadius: BorderRadius.only(
                bottomLeft: widget.message.isMyMessage()
                    ? const Radius.circular(12)
                    : Radius.zero,
                bottomRight: widget.message.isMyMessage()
                    ? Radius.zero
                    : const Radius.circular(12),
                topLeft: const Radius.circular(12),
                topRight: const Radius.circular(12)),
          ),
          child: Column(
            crossAxisAlignment: widget.message.isMyMessage()
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Builder(
                builder: (context) {
                  var msg = widget.message;
                  if (msg is TextMessage) {
                    return TextMessageItem(textMessage: msg);
                  } else if (msg is PhotoMessage) {
                    return PhotoMessageItem(photoMessage: msg);
                  } else if (msg is AudioMessage) {
                    return AudioMessageItem(audioMessage: msg);
                  } else if (msg is VideoMessage) {
                    videoProvider.initialize(msg.fileUrl!);
                    return VideoMessageItem(
                      videoMessage: msg,
                      controller: videoProvider.controllers[msg.fileUrl],
                    );
                  } else {
                    return const Align();
                  }
                },
              ),
              MessaageTimeWidget(msg: widget.message),
            ],
          ),
        ),
      ),
      const SizedBox(width: 30),
    ];
    if (widget.message.isMyMessage()) {
      chatContents = chatContents.reversed.toList();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(
        mainAxisAlignment: widget.message.isMyMessage()
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: chatContents,
      ),
    );
  }
}

class MessaageTimeWidget extends StatelessWidget {
  const MessaageTimeWidget({
    super.key,
    required this.msg,
  });

  final Message msg;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Text(
        msg.createdAt!.toBubbleChatTime,
        style: TextStyle(
          color: msg.isMyMessage() ? Colors.white : Colors.grey,
        ),
      ),
    );
  }
}

class TextMessageItem extends StatelessWidget {
  const TextMessageItem({
    super.key,
    required this.textMessage,
  });

  final TextMessage textMessage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 10,
      ),
      child: Text(
        textMessage.text ?? '',
        style: TextStyle(
          color: textMessage.isMyMessage() ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
