import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/locator.dart';
import '../../../core/utils/resources/color_manager.dart';
import '../../../model/audio_message.dart';
import '../../../providers/audio_provider.dart';
import '/src/core/utils/extensions.dart';

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
    audioProvider = context.read<AudioProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
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
                      audioProvider.isPlaying) {
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
                    initialData: audioProvider.isPlaying,
                    stream: audioProvider.isPlayingStream,
                    builder: (context, snapshot) {
                      final isPlaying = snapshot.data ?? false;
                      return Icon(
                        isCurrentAudio(audioMessage.fileUrl) && isPlaying
                            ? CupertinoIcons.pause_circle
                            : CupertinoIcons.play_arrow_solid,
                        color: ColorManager.offWhite,
                      );
                    }),
              ),
              StreamBuilder<Duration>(
                  initialData: audioProvider.position,
                  stream: audioProvider.positionStream,
                  builder: (context, durationSnapshot) {
                    if (isCurrentAudio(audioMessage.fileUrl) &&
                        durationSnapshot.hasData) {
                      return Text(
                        durationSnapshot.data!.toHms(),
                      );
                    }
                    return const Text('00:00');
                  }),
              Expanded(
                child: StreamBuilder(
                  initialData: audioProvider.position,
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
                        onChanged: audioProvider.onChange,
                      ),
                    );
                  },
                ),
              ),
            ],
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
