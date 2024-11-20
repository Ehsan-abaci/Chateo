import 'package:ehsan_chat/src/core/utils/resources/assets_manager.dart';
import 'package:ehsan_chat/src/core/utils/resources/color_manager.dart';
import 'package:ehsan_chat/src/core/widgets/chateo_icon.dart';
import 'package:flutter/material.dart';

class ChateoMyStoryWidget extends StatelessWidget {
  const ChateoMyStoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 76,
      width: 60,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _getStoryContent(),
          _getStoryText(),
        ],
      ),
    );
  }

  _getStoryContent() {
    return Container(
      height: 60,
      width: 60,
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: ColorManager.disabled, width: 3)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ColoredBox(
          color: ColorManager.offWhite,
          child: const Padding(
            padding: EdgeInsets.all(12.0),
            child: ChateoIcon(
              icon: AssetsIcon.plus,
              height: 30,
              isDisabled: true,
            ),
          ),
        ),
      ),
    );
  }

  _getStoryText() {
    return const Text(
      "Your Story",
      style: TextStyle(
        fontSize: 12,
      ),
    );
  }
}
