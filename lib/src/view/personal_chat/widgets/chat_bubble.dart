import 'package:ehsan_chat/src/core/utils/resources/color_manager.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.content,
    required this.isSentByMe,
    required this.isSeen,
  });

  final String content;
  final bool isSentByMe;
  final bool isSeen;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isSentByMe ? ColorManager.lightBlue : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          bottomLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Directionality(
        textDirection: isSentByMe ? TextDirection.rtl : TextDirection.ltr,
        child: Text(content, style: TextStyle(color: Colors.black)),
      ),
    );
  }
}
