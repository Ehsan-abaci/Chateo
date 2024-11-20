import 'dart:developer';

import 'package:ehsan_chat/src/core/utils/resources/color_manager.dart';
import 'package:ehsan_chat/src/core/utils/utils.dart';
import 'package:ehsan_chat/src/model/media_file.dart';
import 'package:ehsan_chat/src/providers/chat_provider.dart';
import 'package:ehsan_chat/src/providers/personal_chat_cubit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/resources/assets_manager.dart';
import '../../../core/widgets/chateo_icon.dart';

class MessageFieldBottomSheet extends StatelessWidget {
  const MessageFieldBottomSheet({super.key, required this.id});
  final int id;

  void _sendMessasge(BuildContext context) {
    context.read<PersonalChatProvider>().sendNewMessageTo(id);
  }

  void _pickFile(BuildContext context) async {
    final pickedFile =
        await FilePicker.platform.pickFiles(allowMultiple: false);
    if (pickedFile?.isSinglePick ?? false) {
      final file = pickedFile!.files.first.xFile;
      final fileExtension = file.name.split('.').last.toLowerCase();
log(fileExtension);
      final media = MediaFile(
          path: file.path,
          name: file.name,
          type: Utils.messageTypeFromExtension(fileExtension));
      if (context.mounted) {
        context.read<PersonalChatProvider>().setMediaFile(media);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 10),
          InkWell(
            onTap: () async => _pickFile(context),
            child: ChateoIcon(
              icon: AssetsIcon.plus,
              height: 24,
              color: Theme.of(context).dividerColor,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: TextField(
                controller: context.read<PersonalChatProvider>().messageController,
                onSubmitted: (_) async {},
                minLines: 1,
                maxLines: 10,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: ColorManager.offWhite,
                  border: InputBorder.none,
                  hintText: "Message",
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Consumer<ChatProvider>(
            builder: (context, chatProvider, child) {
              if (chatProvider.connectionState == 'Connected') {
                return InkWell(
                  borderRadius: BorderRadius.circular(20),
                  radius: 40,
                  splashColor: ColorManager.neutralActive,
                  onTap: () => _sendMessasge(context),
                  child: ChateoIcon(
                    icon: AssetsIcon.send,
                    height: 24,
                    color: ColorManager.lightBlue,
                  ),
                );
              }
              return SizedBox.square(
                dimension: 30,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: ColorManager.brandDefault,
                ),
              );
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
