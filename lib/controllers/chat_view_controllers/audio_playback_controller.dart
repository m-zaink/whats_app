import 'package:flutter/foundation.dart';
import 'package:whats_app/utils/audio_utils/audio_player.dart';
import 'package:whats_app/utils/audio_utils/track_details.dart';

class AudioPlaybackState {
  final bool isPlaying;

  AudioPlaybackState({this.isPlaying = false});

  AudioPlaybackState copyWith({bool isPlaying}) {
    return AudioPlaybackState(
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }
}

abstract class AudioPlaybackController extends ChangeNotifier {
  AudioPlaybackState get currentState;

  factory AudioPlaybackController({@required TrackDetails trackDetails}) => _AudioPlaybackControllerImpl(trackDetails);

  void startPlaying();

  void stopPlaying();
}

class _AudioPlaybackControllerImpl extends ChangeNotifier implements AudioPlaybackController {
  final AudioPlayer _audioPlayer;
  final TrackDetails _trackDetails;

  @override
  AudioPlaybackState currentState;

  _AudioPlaybackControllerImpl(this._trackDetails)
      : this._audioPlayer = AudioPlayer(),
        this.currentState = AudioPlaybackState();

  @override
  void startPlaying() async {
    final isPlaying = await _audioPlayer.startPlayback(
      _trackDetails,
      onPlaybackFinished: () {
        if (currentState.isPlaying) {
          updateState(currentState.copyWith(isPlaying: false));
        }
      },
    );

    updateState(currentState.copyWith(isPlaying: isPlaying));
  }

  @override
  void stopPlaying() async {
    await _audioPlayer.stopPlayback();
    updateState(currentState.copyWith(isPlaying: false));
  }

  void updateState(AudioPlaybackState updatedState) {
    currentState = updatedState;

    _notifyListeners();
  }

  void _notifyListeners() {
    notifyListeners();
  }
}
