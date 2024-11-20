import 'dart:developer';

import 'package:flutter/foundation.dart';
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
    final player = Player();
    final controller = VideoController(player,
        configuration: const VideoControllerConfiguration(
            enableHardwareAcceleration: false));
    final media = Media('${Constants.serverUrl}$url');
    log(media.uri);
    await player.open(media, play: false);

    _players.add(player);
    _controllers[url] = (controller);

    notifyListeners();
  }

  @override
  void dispose() async {
    for (final p in _players) {
      await p.dispose();
    }
    super.dispose();
  }
}
