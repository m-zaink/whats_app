import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:whats_app/controllers/chat_view_controllers/chat_controller.dart';
import 'package:whats_app/models/messages/recorded_audio_message.dart';
import 'package:whats_app/utils/audio_utils/audio_recorder.dart';
import 'package:whats_app/utils/audio_utils/track_details.dart';
import 'package:whats_app/utils/permission_utils/permission_utils.dart';

class RecordState {
  final bool isRecording;
  final int secondsElapsedSinceRecordingStarted;

  RecordState({this.isRecording = false, this.secondsElapsedSinceRecordingStarted = 0})
      : assert(isRecording != null, 'isRecording cannot be null'),
        assert(secondsElapsedSinceRecordingStarted != null, 'secondsElapsedSinceRecordingStarted cannot be null');

  RecordState copyWith({
    bool isRecording,
    int secondsElapsedSinceRecordingStarted,
  }) {
    return RecordState(
      isRecording: isRecording ?? this.isRecording,
      secondsElapsedSinceRecordingStarted:
          secondsElapsedSinceRecordingStarted ?? this.secondsElapsedSinceRecordingStarted,
    );
  }
}

abstract class AudioRecordingController extends ChangeNotifier {
  RecordState get currentState;

  factory AudioRecordingController({@required ChatController chatController}) =>
      _AudioRecordingControllerImpl(chatController: chatController);

  void startRecording();

  void stopRecording();

  void cancelRecording();
}

class _AudioRecordingControllerImpl extends ChangeNotifier implements AudioRecordingController {
  AudioRecorder _audioRecorder;
  ChatController _chatController;

  @override
  RecordState currentState = RecordState();

  _AudioRecordingControllerImpl({@required ChatController chatController})
      : assert(chatController != null, 'chatWidgetController cannot be null'),
        this.currentState = RecordState(),
        this._audioRecorder = AudioRecorder(),
        this._chatController = chatController;

  TrackDetails _temporaryTrackDetails;
  Timer _recordingDurationTimer;

  @override
  void startRecording() async {
    final isMicrophonePermissionGranted = await requestMicrophonePermission();

    if (isMicrophonePermissionGranted) {
      _temporaryTrackDetails = await _audioRecorder.startRecording();

      final isRecording = _temporaryTrackDetails != null;

      if (isRecording) {
        _updateState(currentState.copyWith(isRecording: true));
        _createTimerToTrackRecordingDuration();
      }
    }
  }

  @override
  void stopRecording() async {
    await _audioRecorder.finishRecording();

    _updateState(
      currentState.copyWith(
        isRecording: false,
        secondsElapsedSinceRecordingStarted: 0,
      ),
    );

    _addRecordedMessageToChat();
    _clearTemporaryTrackDetails();
  }

  @override
  void cancelRecording() async {
    if (_temporaryTrackDetails != null) {
      await _audioRecorder.cancelRecording();

      _updateState(
        currentState.copyWith(
          isRecording: false,
          secondsElapsedSinceRecordingStarted: 0,
        ),
      );

      _clearTemporaryTrackDetails();
    }
  }

  void _createTimerToTrackRecordingDuration() {
    _recordingDurationTimer = Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        if (currentState.isRecording) {
          print('isRecording = true');
          final updatedState = currentState.copyWith(
            secondsElapsedSinceRecordingStarted: currentState.secondsElapsedSinceRecordingStarted + 1,
          );

          _updateState(updatedState);
        } else {
          print('isRecording = false');
          final updatedState = currentState.copyWith(
            secondsElapsedSinceRecordingStarted: 0,
          );

          _updateState(updatedState);
          timer.cancel();
        }
      },
    );
  }

  void _addRecordedMessageToChat() {
    final recordedAudioMessage = RecordedAudioMessage(trackDetails: _temporaryTrackDetails);

    _chatController.addMessage(recordedAudioMessage);
  }

  void _clearTemporaryTrackDetails() {
    _temporaryTrackDetails = null;
  }

  void _updateState(RecordState updatedState) {
    currentState = updatedState;
    _notifyListeners();
  }

  void _notifyListeners() {
    notifyListeners();
  }
}
