import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/constants.dart';
import '../../../core/utils/resources/assets_manager.dart';
import '../../../model/message.dart';

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
