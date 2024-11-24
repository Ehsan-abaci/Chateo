import 'dart:developer';

import 'package:ehsan_chat/main.dart';
import 'package:ehsan_chat/src/core/utils/resources/color_manager.dart';
import 'package:ehsan_chat/src/providers/audio_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AudioBarController extends StatefulWidget {
  const AudioBarController({super.key});

  @override
  State<AudioBarController> createState() => _AudioBarControllerState();
}

class _AudioBarControllerState extends State<AudioBarController> {
  late AudioProvider audioProvider;

  @override
  void initState() {
    audioProvider = context.read<AudioProvider>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioProvider>(
      builder: (context, value, child) {
        final isVisible = value.isPlaying && value.currentAudioUrl != null;

        return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: isVisible ? 30 : 0, // ارتفاع وقتی موزیک پخش می‌شود
            decoration: BoxDecoration(
              color: ColorManager.neutralDark,
              boxShadow: isVisible
                  ? [
                      const BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, -2),
                      ),
                    ]
                  : [],
            ),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 100),
              opacity: isVisible ? 1 : 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StreamBuilder<bool>(
                    initialData: audioProvider.isPlaying,
                    stream: audioProvider.isPlayingStream,
                    builder: (context, snapshot) {
                      final isPlaying = snapshot.data ?? false;
                      log("$isPlaying");
                      return IconButton(
                        padding: EdgeInsets.zero,
                        color: ColorManager.brandBg,
                        onPressed: () {
                          isPlaying
                              ? audioProvider.pauseAudio()
                              : audioProvider.resume();
                        },
                        icon: Icon(
                          isPlaying
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                        ),
                      );
                    },
                  ),
                  Expanded(
                    child: Text(
                      'Music is playing...',
                      style: TextStyle(
                        color: ColorManager.disabled,
                      ),
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    color: ColorManager.brandBg,
                    onPressed: () {
                      audioProvider.stopAudio();
                    },
                    icon: const Icon(
                      Icons.close_rounded,
                    ),
                  ),
                ],
              ),
            ));
      },
    );
  }
}
