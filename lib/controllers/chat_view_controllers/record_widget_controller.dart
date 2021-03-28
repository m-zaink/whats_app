import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:whats_app/controllers/chat_view_controllers/chat_widget_controller.dart';
import 'package:whats_app/models/messages/recorded_audio_message.dart';
import 'package:whats_app/utils/audio_utils/audio_recorder.dart';
import 'package:whats_app/utils/audio_utils/track_details.dart';

class RecordState {
  final bool isRecording;
  final int secondsElapsedSinceRecordingStarted;

  RecordState(
      {this.isRecording = false, this.secondsElapsedSinceRecordingStarted = 0})
      : assert(isRecording != null, 'isRecording cannot be null'),
        assert(secondsElapsedSinceRecordingStarted != null,
            'secondsElapsedSinceRecordingStarted cannot be null');

  RecordState copyWith(
      {bool isRecording = false, int secondsElapsedSinceRecordingStarted}) {
    return RecordState(
      isRecording: isRecording ?? this.isRecording,
      secondsElapsedSinceRecordingStarted:
          secondsElapsedSinceRecordingStarted ??
              this.secondsElapsedSinceRecordingStarted,
    );
  }
}

abstract class RecordWidgetController extends ChangeNotifier {
  RecordState get currentState;

  void startRecording();

  void stopRecording();

  void cancelRecording();
}

class _RecordWidgetControllerImpl extends ChangeNotifier
    implements RecordWidgetController {
  AudioRecorder _audioRecorder;
  ChatWidgetController _chatWidgetController;

  @override
  RecordState currentState = RecordState();

  _RecordWidgetControllerImpl(
      {@required ChatWidgetController chatWidgetController})
      : assert(chatWidgetController != null,
            'chatWidgetController cannot be null'),
        this.currentState = RecordState(),
        this._audioRecorder = AudioRecorder(),
        this._chatWidgetController = chatWidgetController;

  TrackDetails _temporaryTrackDetails;
  Timer _recordingDurationTimer;

  @override
  void startRecording() async {
    _temporaryTrackDetails = await _audioRecorder.startRecording();

    final isRecording = _temporaryTrackDetails != null;

    if (isRecording) {
      _updateState(currentState.copyWith(isRecording: isRecording));
      _createTimerToTrackRecordingDuration();
    } else {
      _updateState(currentState.copyWith(isRecording: isRecording));
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
          final updatedState = currentState.copyWith(
            secondsElapsedSinceRecordingStarted:
                currentState.secondsElapsedSinceRecordingStarted + 1,
          );

          _updateState(updatedState);
        } else {
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
    final recordedAudioMessage =
        RecordedAudioMessage(trackDetails: _temporaryTrackDetails);

    _chatWidgetController.addMessage(recordedAudioMessage);
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
