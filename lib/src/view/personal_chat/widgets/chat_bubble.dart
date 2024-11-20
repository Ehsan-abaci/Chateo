import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ehsan_chat/src/core/utils/constants.dart';
import 'package:ehsan_chat/src/core/utils/extensions.dart';
import 'package:ehsan_chat/src/core/utils/locator.dart';
import 'package:ehsan_chat/src/core/utils/resources/assets_manager.dart';
import 'package:ehsan_chat/src/core/utils/resources/color_manager.dart';
import 'package:ehsan_chat/src/model/audio_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:provider/provider.dart';

import '../../../model/message.dart';
import '../../../model/video_message.dart';
import '../../../providers/audio_provider.dart';
import '../../../providers/video_provider.dart';

class ChatBubble extends StatefulWidget {
  ChatBubble({
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
    videoProvider = di<VideoProvider>();
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
                  var localMessage = widget.message;
                  if (localMessage is TextMessage) {
                    return TextMessageItem(textMessage: localMessage);
                  } else if (localMessage is PhotoMessage) {
                    return PhotoMessageItem(photoMessage: localMessage);
                  } else if (localMessage is AudioMessage) {
                    return AudioMessageItem(audioMessage: localMessage);
                  } else if (localMessage is VideoMessage) {
                    VideoController? controller;
                    di<VideoProvider>()
                        .initialize(localMessage.fileUrl!);
                    return ChangeNotifierProvider.value(
                      value: di<VideoProvider>(),
                      child: Selector<VideoProvider,
                              Map<String, VideoController>>(
                          selector: (p0, p1) => p1.controllers,
                          shouldRebuild: (previous, next) =>
                              previous[localMessage.fileUrl] != null,
                          builder: (context, controllers, child) {
                            controller = controllers[localMessage.fileUrl];
                            if (controller == null) {
                              return const SizedBox.shrink();
                            } else {
                              return SizedBox(
                                height: 300,
                                width: 320,
                                child: VideoMessageItem(
                                  videoMessage: localMessage,
                                  controller: controller!,
                                ),
                              );
                            }
                          }),
                    );
                  } else {
                    return Align();
                  }
                },
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Text(
                  widget.message.createdAt!.toBubbleChatTime,
                  style: TextStyle(
                    color: widget.message.isMyMessage()
                        ? Colors.white
                        : Colors.grey,
                  ),
                ),
              ),
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

class VideoMessageItem extends StatelessWidget {
  VideoMessageItem({
    super.key,
    required this.videoMessage,
    required this.controller,
  });
  final VideoMessage videoMessage;
  final VideoController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Video(
            fit: BoxFit.cover,
            controller: controller,
            wakelock: false,
          ),
        ),
        if (videoMessage.text!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 10,
            ),
            child: Text(
              videoMessage.text!,
              style: TextStyle(
                color: videoMessage.isMyMessage() ? Colors.white : Colors.black,
              ),
            ),
          ),
      ],
    );
  }
}

class AudioMessageItem extends StatelessWidget {
  AudioMessageItem({
    super.key,
    required this.audioMessage,
  });
  final AudioMessage audioMessage;
  late final AudioProvider audioProvider;

  bool isCurrentAudio(String? fileUrl) =>
      audioProvider.currentAudioUrl == fileUrl;

  @override
  Widget build(BuildContext context) {
    audioProvider = di<AudioProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ChangeNotifierProvider.value(
          value: audioProvider,
          child: Consumer<AudioProvider>(
            builder: (context, audioPlayer, child) => Container(
              width: 200,
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: ColorManager.brandLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (isCurrentAudio(audioMessage.fileUrl) &&
                          audioPlayer.isPlaying) {
                        audioProvider.pauseAudio();
                        return;
                      }
                      if (isCurrentAudio(audioMessage.fileUrl)) {
                        audioProvider.resume();
                        return;
                      }
          
                      audioProvider.playAudio(audioMessage.fileUrl!);
                    },
                    icon: StreamBuilder<bool>(
                        stream: audioPlayer.isPlayingStream,
                        builder: (context, snapshot) {
                          return Icon(
                            isCurrentAudio(audioMessage.fileUrl) &&
                                    (snapshot.data ?? false)
                                ? CupertinoIcons.pause_circle
                                : CupertinoIcons.play_arrow_solid,
                            color: ColorManager.offWhite,
                          );
                        }),
                  ),
                  StreamBuilder(
                      stream: audioProvider.positionStream,
                      builder: (context, snapshot) {
                        if (isCurrentAudio(audioMessage.fileUrl)) {
                          return Text(
                            '${snapshot.data?.toHms()}',
                          );
                        }
                        return const Text('00:00');
                      }),
                  Expanded(
                    child: StreamBuilder(
                      stream: audioProvider.positionStream,
                      builder: (context, snapshot) {
                        final currentPos = snapshot.data ?? Duration.zero;
                        return SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            thumbShape: SliderComponentShape.noThumb,
                          ),
                          child: Slider.adaptive(
                            value: isCurrentAudio(audioMessage.fileUrl)
                                ? currentPos.inSeconds.toDouble()
                                : 0,
                            max: audioProvider.duration.inSeconds > 0
                                ? audioProvider.duration.inSeconds.toDouble()
                                : double.infinity,
                            activeColor: ColorManager.brandDarkMode,
                            thumbColor: ColorManager.offWhite,
                            onChanged: audioPlayer.onChange,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (audioMessage.text!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 10,
            ),
            child: Text(
              audioMessage.text!,
              style: TextStyle(
                color: audioMessage.isMyMessage() ? Colors.white : Colors.black,
              ),
            ),
          ),
      ],
    );
  }
}

class PhotoMessageItem extends StatelessWidget {
  const PhotoMessageItem({
    super.key,
    required this.photoMessage,
  });

  final PhotoMessage photoMessage;

  @override
  Widget build(BuildContext context) {
    final photoUrl = photoMessage.fileUrl ?? '';
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            imageUrl: '${Constants.serverUrl}$photoUrl',
            matchTextDirection: true,
            maxHeightDiskCache: 300,
            maxWidthDiskCache: 300,
            fadeInDuration: const Duration(milliseconds: 200),
            fadeOutDuration: const Duration(milliseconds: 200),
            placeholder: (context, url) => Image.asset(
              fit: BoxFit.fitWidth,
              AssetsImage.placeholder,
              height: 100,
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        if (photoMessage.text!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 10,
            ),
            child: Text(
              photoMessage.text!,
              style: TextStyle(
                color: photoMessage.isMyMessage() ? Colors.white : Colors.black,
              ),
            ),
          ),
      ],
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
