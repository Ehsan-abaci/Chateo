import 'package:flutter/foundation.dart';
import 'package:media_kit/media_kit.dart';

import '../core/utils/constants.dart';

class AudioProvider extends ChangeNotifier {
  final Player mediaPlayer = Player();

  Stream<Duration> get positionStream => mediaPlayer.stream.position;
  Duration get position => mediaPlayer.state.position;

  Duration get duration => mediaPlayer.state.duration;

  Stream<bool> get isPlayingStream => mediaPlayer.stream.playing;
  bool get isPlaying => mediaPlayer.state.playing;

  String? currentAudioUrl;

  onChange(double pos) {
    if (pos.isInfinite || pos.isNaN) return;
    mediaPlayer.seek(Duration(seconds: pos.toInt()));
  }

  Future<void> resume() async {
    mediaPlayer.play();
    notifyListeners();
  }

  Future<void> playAudio(String url) async {
    try {
      stopAudio();
      final media =
          Media('${Constants.serverUrl}$url', extras: {'singer': 'Shadmehr'});
      await mediaPlayer.open(media);
      currentAudioUrl = url;
      notifyListeners();
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  Future<void> stopAudio() async {
    try {
      currentAudioUrl = null;
      notifyListeners();
      mediaPlayer.stop();
    } catch (e) {
      print("Error stopping audio: $e");
    }
  }

  Future<void> pauseAudio() async {
    try {
      mediaPlayer.pause();
    } catch (e) {
      print("Error pausing audio: $e");
    }
  }

  @override
  void dispose() {
    mediaPlayer.dispose();
    super.dispose();
  }
}
