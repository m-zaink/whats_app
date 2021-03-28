import 'dart:io';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:whats_app/utils/audio_utils/track_details.dart';
import 'package:whats_app/utils/logger_utils/logger_util.dart';

abstract class AudioRecorder {
  factory AudioRecorder() => _AudioPlayerImpl();

  Future<TrackDetails> startRecording();

  Future<void> finishRecording();

  Future<void> cancelRecording();
}

class _AudioPlayerImpl implements AudioRecorder {
  FlutterSoundRecorder _flutterSoundRecorder = FlutterSoundRecorder();

  @override
  Future<TrackDetails> startRecording() async {
    if (_flutterSoundRecorder.isRecording) {
      logger.e('Start recording failed: Recording is already in progress');
      return null;
    }

    final audioFilePath = await _createFilePathBasedOnCurrentTime();

    try {
      await _flutterSoundRecorder.openAudioSession();
      await _flutterSoundRecorder.startRecorder(toFile: audioFilePath);

      logger.d('Start recording successful');

      return TrackDetails(
        url: audioFilePath,
      );
    } catch (e) {
      print('Recording failed : $e');
      return null;
    }
  }

  @override
  Future<void> finishRecording() async {
    await _stopRecording();
    logger.d('Finished recording successful');
  }

  @override
  Future<void> cancelRecording() async {
    final trackUrl = await _stopRecording();
    _removeRecordedFile(trackUrl);
  }

  Future<String> _stopRecording() async {
    if (!_flutterSoundRecorder.isRecording) {
      return '';
    }

    final trackUrl = await _flutterSoundRecorder.stopRecorder();
    await _flutterSoundRecorder.closeAudioSession();
    return trackUrl;
  }

  void _removeRecordedFile(String filePath) async {
    try {
      final file = File(filePath);
      await file.delete();
    } catch (e) {
      logger.e('File deletion failed: $e');
    }
  }
}

Future<String> _createFilePathBasedOnCurrentTime() async {
  final applicationsDirectory = await getApplicationDocumentsDirectory();
  final audioFilePath = applicationsDirectory.path + '/${DateTime.now().millisecondsSinceEpoch}.mp3';

  return audioFilePath;
}
