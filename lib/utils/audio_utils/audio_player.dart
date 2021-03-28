import 'package:flutter/cupertino.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:whats_app/utils/audio_utils/track_details.dart';
import 'package:whats_app/utils/logger_utils/logger_util.dart';

abstract class AudioPlayer {
  factory AudioPlayer() => _AudioPlayerImpl();

  Future<bool> startPlayback(
    TrackDetails trackDetails, {
    VoidCallback onPlaybackFinished,
  });

  Future<void> stopPlayback();
}

class _AudioPlayerImpl implements AudioPlayer {
  FlutterSoundPlayer _flutterSoundPlayer = FlutterSoundPlayer();

  @override
  Future<bool> startPlayback(TrackDetails trackDetails,
      {VoidCallback onPlaybackFinished}) async {
    if (_flutterSoundPlayer.isPlaying) {
      return false;
    }

    try {
      await _flutterSoundPlayer.openAudioSession();
      await _flutterSoundPlayer.startPlayer(
        fromURI: trackDetails.url,
        whenFinished: () async {
          await _flutterSoundPlayer.closeAudioSession();
          onPlaybackFinished?.call();

          logger.d('Playback completed');
        },
      );

      logger.d('Stack playback successful');

      return true;
    } catch (e) {
      logger.e('Start playback failed : $e');
      return false;
    }
  }

  @override
  Future<void> stopPlayback() async {
    if (!_flutterSoundPlayer.isPlaying) {
      return;
    }

    await _flutterSoundPlayer.stopPlayer();
    await _flutterSoundPlayer.closeAudioSession();
  }
}
