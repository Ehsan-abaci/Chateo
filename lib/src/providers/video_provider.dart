import 'dart:async';
import 'dart:developer';

import 'package:ehsan_chat/src/services/download_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

import '../core/utils/constants.dart';

class VideoProvider extends ChangeNotifier {
  final List<Player> _players = [];
  final Map<String, VideoController> _controllers = {};

  Map<String, VideoController> get controllers => _controllers;
  List<Player> get players => _players;

  String? currentVideoUrl;

  Future<void> initialize(String url) async {
    if (_controllers.containsKey(url)) {
      return;
    }

    final media = await _getMediaResource(url);
    if (media == null) return;

    await _createPlayerAndController(media, url);

    // notifyListeners();
  }

  Future<void> _createPlayerAndController(Media media, String url) async {
    final player = Player();
    final controller = VideoController(
      player,
      configuration: const VideoControllerConfiguration(
        enableHardwareAcceleration: true,
      ),
    );

    _players.add(player);
    _controllers[url] = controller;
    await player.open(media, play: false);
    notifyListeners();
  }

  Future<VideoController> setPathToMediaPlayer(String path, String url) async {
    if (_controllers.containsKey(url)) return controllers[url]!;
    final media = Media(path);
    await _createPlayerAndController(media, url);
    return controllers[url]!;
  }

  Future<Media?> _getMediaResource(String url) async {
    final cachedPath = await DownloadService().checkIfFileCachedWith(url).first;
    Media? media;
    if (cachedPath != null) {
      media = Media(cachedPath);
    }
    return media;
  }

  @override
  void dispose() async {
    for (final p in _players) {
      await p.dispose();
    }
    super.dispose();
  }
}
