import 'dart:async';
import 'dart:developer';

import 'package:ehsan_chat/main.dart';
import 'package:ehsan_chat/src/controller/private_chat_controller.dart';
import 'package:ehsan_chat/src/core/utils/extensions.dart';
import 'package:ehsan_chat/src/core/utils/resources/assets_manager.dart';
import 'package:ehsan_chat/src/core/widgets/chateo_icon.dart';
import 'package:ehsan_chat/src/model/user.dart';
import 'package:ehsan_chat/src/view/chats/cubits/saved_chats/saved_chats_cubit.dart';
import 'package:ehsan_chat/src/view/navbar/screen_navbar.dart';
import 'package:ehsan_chat/src/view/personal_chat/cubit/messages_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/utils/resources/color_manager.dart';
import '../../model/message.dart';

class PersonalChat extends StatefulWidget {
  const PersonalChat({super.key, required this.user});

  final Users user;

  @override
  State<PersonalChat> createState() => _PersonalChatState();
}

class _PersonalChatState extends State<PersonalChat> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _editMessageController = TextEditingController();

  var _listener;

  bool isEditing = false;

  Future<void> _updateMessage(Message message) async {
    if (_editMessageController.text.isEmpty) return;

    await PrivateChatController().updateMessage(message);
    _editMessageController.clear();
    setState(() {
      isEditing = false;
    });
  }

  Message? _currentMessage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _listener = supabase
        .channel('public:messages')
        .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'messages',
            filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: "conversation_id",
              value: 1,
            ),
            callback: (payload) async {
              final meesage =
                  Message.fromJson(map: payload.newRecord, myUserId: myUserId);
              if (payload.eventType == PostgresChangeEvent.insert) {
                context.read<MessagesCubit>().addMessage(meesage);
              } else if (payload.eventType == PostgresChangeEvent.update) {
                context.read<MessagesCubit>().updateMessage(meesage);
              }
              await context.read<SavedChatsCubit>().saveChat(widget.user);
            })
        .subscribe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.sizeOf(context).height * .9 -
            MediaQuery.viewInsetsOf(context).bottom,
        child: Column(
          children: [
            _getAppbar(),
            _getChatContent(),
          ],
        ),
      ),
      bottomSheet: _getBottomSheet(),
    );
  }

  _getChatContent() {
    return Expanded(
      child: ColoredBox(
        color: ColorManager.offWhite,
        child: BlocBuilder<MessagesCubit, MessagesState>(
          builder: (context, state) {
            final messages = state.messages;
            return ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, i) {
                return GestureDetector(
                  onTap: () {
                    if (!messages[i].isMine) return;
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        child: ListTile(
                          onTap: () {
                            setState(() {
                              isEditing = true;
                              _editMessageController.text = messages[i].content;
                            });
                            _currentMessage = messages[i];
                            Navigator.pop(context);
                          },
                          title: const Text("Edit message"),
                        ),
                      ),
                    );
                  },
                  child: _ChatBubble(
                    message: messages[i],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  _getBottomSheet() {
    return Container(
      height: 80,
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          ChateoIcon(
            icon: AssetsIcon.plus,
            height: 24,
            isDisabled: true,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: TextField(
                controller:
                    isEditing ? _editMessageController : _messageController,
                onSubmitted: (_) async {
                  if (isEditing) {
                    _currentMessage = _currentMessage?.copyWith(
                        content: _editMessageController.text);
                    _updateMessage(_currentMessage!);
                  } else {
                    if (_messageController.text.isEmpty) return;
                    await PrivateChatController().newMessage({
                      "user_id": myUserId,
                      "receiver": widget.user.intId,
                      "content": _messageController.text
                    });
                    _messageController.clear();
                  }
                },
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
          GestureDetector(
            onTap: () async {
              if (isEditing) {
                _currentMessage = _currentMessage?.copyWith(
                    content: _editMessageController.text);
                _updateMessage(_currentMessage!);
              } else {
                if (_messageController.text.isEmpty) return;
                await PrivateChatController().newMessage({
                  "user_id": myUserId,
                  "receiver": widget.user.intId,
                  "content": _messageController.text
                });
                _messageController.clear();
              }
            },
            child: ChateoIcon(
              icon: AssetsIcon.send,
              height: 24,
              color: ColorManager.lightBlue,
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  _getAppbar() {
    return Container(
      height: 100,
      decoration: const BoxDecoration(color: Colors.white),
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: ChateoIcon(icon: AssetsIcon.chevronLeft, height: 30),
          ),
          const SizedBox(width: 10),
          Text(
            widget.user.fullname,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({
    Key? key,
    required this.message,
  }) : super(key: key);

  final Message message;

  @override
  Widget build(BuildContext context) {
    List<Widget> chatContents = [
      const SizedBox(width: 12),
      Flexible(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 12,
          ),
          decoration: BoxDecoration(
            color: message.isMine ? ColorManager.darkBlue : Colors.white,
            borderRadius: BorderRadius.only(
                bottomLeft:
                    message.isMine ? const Radius.circular(16) : Radius.zero,
                bottomRight:
                    message.isMine ? Radius.zero : const Radius.circular(16),
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16)),
          ),
          child: Column(
            crossAxisAlignment: message.isMine
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Text(
                message.content,
                style: TextStyle(
                  color: message.isMine ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!message.createdAt.isAtSameMomentAs(message.updatedAt))
                    Text(
                      "eddited",
                      style: TextStyle(
                        color: Colors.grey.shade300,
                      ),
                    ),
                  Text(
                    message.createdAt.toHourMinute(),
                    style: TextStyle(
                      color: message.isMine ? Colors.white : Colors.grey,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      const SizedBox(width: 60),
    ];
    if (message.isMine) {
      chatContents = chatContents.reversed.toList();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
      child: Row(
        mainAxisAlignment:
            message.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: chatContents,
      ),
    );
  }
}
