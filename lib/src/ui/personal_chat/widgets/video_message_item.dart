import 'package:ehsan_chat/src/model/video_message.dart';
import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:provider/provider.dart';

import '../../../data/services/remote/download_service.dart';
import '../../../providers/video_provider.dart';

class VideoMessageItem extends StatelessWidget {
  VideoMessageItem({
    super.key,
    required this.videoMessage,
    required this.controller,
  });
  final VideoMessage videoMessage;
  VideoController? controller;

  final DownloadService downloadService = DownloadService();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: 320,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _getVideoContent(),
          if (videoMessage.text!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 5,
                horizontal: 10,
              ),
              child: Text(
                videoMessage.text!,
                style: TextStyle(
                  color:
                      videoMessage.isMyMessage() ? Colors.white : Colors.black,
                ),
              ),
            ),
        ],
      ),
    );
  }

  _getVideoContent() {
    return StreamBuilder<String?>(
      initialData: null,
      stream: downloadService.checkIfFileCachedWith(videoMessage.fileUrl!),
      builder: (context, snapshot) {
        if (snapshot.data == null || !snapshot.hasData) {
          return _getVideoDownloadButton();
        }
        final path = snapshot.data!;

        return FutureBuilder<VideoController>(
            future: context
                .read<VideoProvider>()
                .setPathToMediaPlayer(path, videoMessage.fileUrl!),
            builder: (context, snapshot) {
              controller = snapshot.data;
              if (controller == null) return _getVideoDownloadButton();
              return Expanded(
                child: Video(
                  controller: controller!,
                  wakelock: false,
                ),
              );
            });
      },
    );
  }

  Widget _getVideoDownloadButton() {
    return Expanded(
      child: Container(
        color: Colors.black,
        child: Center(
          child: InkWell(
            onTap: () => downloadService.downloadFile(
              videoMessage.fileUrl!,
              videoMessage,
            ),
            child: ValueListenableBuilder<double>(
                valueListenable: videoMessage.downloadProgress,
                builder: (context, value, _) {
                  return (value < 1.0)
                      ? CircularProgressIndicator(
                          value: value,
                        )
                      : const CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          child: Icon(Icons.download),
                        );
                }),
          ),
        ),
      ),
    );
  }
}
